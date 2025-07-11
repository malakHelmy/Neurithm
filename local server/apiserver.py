from flask import Flask, request, jsonify, send_file, Response
import io
import zipfile
import pandas as pd
import numpy as np
import os
from pathlib import Path
import json
import logging
import nbformat
from nbconvert.preprocessors import ExecutePreprocessor
import tensorflow as tf
import pickle
from functools import lru_cache
from pyngrok import ngrok
import requests
from dotenv import load_dotenv
import os
import re

# Setup Logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

app = Flask(__name__)

# Load environment variables from .env file
load_dotenv()


# Constants
NOTEBOOK_PATH = "notebooks/Letters_notebook_file_by_file.ipynb"
MODEL_PATH = "models/best_eegnet_hybrid_model.keras"
LABEL_ENCODER_PATH = "models/label_encoder_eegnet_hybrid_final.pkl"
# Add path for the alternative model
ALT_MODEL_PATH = "models/eegnet_model_letters 81.31.keras"
ALT_LABEL_ENCODER_PATH = "models/label_encoder_eegnet_letters 81.31.pkl"
OUTPUT_DIR = Path("processed_results")

# Access the API key from the environment
OPENROUTER_API_KEY = ""
OPENROUTER_API_URL = "https://openrouter.ai/api/v1/chat/completions"
MODEL_NAME = "deepseek/deepseek-chat-v3-0324"
MAX_RETRIES = 3

print(f"Your OpenRouter API Key is: {OPENROUTER_API_KEY}")


# Load primary model once
try:
    model = tf.keras.models.load_model(MODEL_PATH)
    logger.info("✅ Primary model loaded successfully.")
except Exception as e:
    logger.error(f"❌ Error loading primary model: {e}")
    raise e

# Load primary label encoder once
try:
    with open(LABEL_ENCODER_PATH, "rb") as f:
        label_encoder = pickle.load(f)
    num_classes = len(label_encoder.classes_)
    logger.info(f"✅ Primary label encoder loaded successfully. Total classes: {num_classes}")
except Exception as e:
    logger.error(f"❌ Error loading primary label encoder: {e}")
    raise e


# Load alternative model (EEGNET and EEG Transformer)
try:
    alt_model = tf.keras.models.load_model(ALT_MODEL_PATH)
    logger.info("✅ Alternative EEGTransformer model loaded successfully.")
except Exception as e:
    logger.error(f"❌ Error loading EEGTransformer model: {e}")
    raise e

# Load alternative label encoder
try:
    with open(ALT_LABEL_ENCODER_PATH, "rb") as f:
        alt_label_encoder = pickle.load(f)
    alt_num_classes = len(alt_label_encoder.classes_)
    logger.info(f"✅ Alternative label encoder loaded. Classes: {alt_num_classes}")
except Exception as e:
    logger.error(f"❌ Error loading alternative label encoder: {e}")
    raise e

for i, input_tensor in enumerate(alt_model.inputs):
    print(f"Input {i}: name={input_tensor.name}, shape={input_tensor.shape}, dtype={input_tensor.dtype}")
print(alt_model.inputs)


# Ensure output folder exists
def setup_folders():
    OUTPUT_DIR.mkdir(exist_ok=True)

def get_next_word_id():
    """Get next sequential word ID (word1, word2, ...)"""
    existing = []
    for f in OUTPUT_DIR.glob("word*"):
        if f.is_dir():
            try:
                num = int(f.name[4:]) 
                existing.append(num)
            except ValueError:
                continue
    return max(existing) + 1 if existing else 1

def process_eeg_data(df, sample_rate=128, letter_duration=10, gap=0.5):
    """Split EEG DataFrame into letter segments with gap between them, no gap after the last one."""
    rows_per_letter = sample_rate * letter_duration
    rows_per_gap = int(sample_rate * gap)
    segments = []

    for start in range(0, len(df), rows_per_letter + rows_per_gap):
        if start + rows_per_letter + rows_per_gap > len(df):
            end = min(start + rows_per_letter, len(df))
        else:
            end = min(start + rows_per_letter, len(df))
        segments.append(df.iloc[start:end].copy())

    return segments


def handle_upload(file):
    """Handle uploaded EEG CSV file, split into segments"""
    setup_folders()
    word_id = get_next_word_id()
    word_path = OUTPUT_DIR / f"word{word_id}"
    word_path.mkdir(exist_ok=True)

    df = pd.read_csv(file)
    df.replace([np.nan, 'nan', 'NaN'], np.nan, inplace=True)

    segments = process_eeg_data(df)
    for i, segment in enumerate(segments, 1):
        segment.to_csv(word_path / f"letter_{i}.csv", index=False)

    # Create in-memory zip
    zip_buffer = io.BytesIO()
    with zipfile.ZipFile(zip_buffer, 'w') as zf:
        for csv_file in word_path.glob("*.csv"):
            zf.write(csv_file, csv_file.name)

    zip_buffer.seek(0)
    return zip_buffer, str(word_path.absolute())

def run_notebook(folder_path):
    """Run preprocessing Jupyter notebook"""
    try:
        safe_folder_path = folder_path.replace("\\", "/")
        with open(NOTEBOOK_PATH, "r", encoding="utf-8") as f:
            nb = nbformat.read(f, as_version=4)

        new_cell = nbformat.v4.new_code_cell(f'CSV_Folder_PATH = r"{safe_folder_path}"')
        nb.cells.insert(0, new_cell)

        ep = ExecutePreprocessor(timeout=600, kernel_name="python3")
        logger.info("🔄 Running Jupyter Notebook preprocessing...")

        ep.preprocess(nb, {"metadata": {"path": os.path.dirname(NOTEBOOK_PATH)}})

        logger.info("✅ Notebook executed successfully.")
        return folder_path

    except Exception as e:
        logger.error(f"⚠ Notebook execution error: {e}")
        return None


def run_predictions_in_memory(folder_path, model_path, label_encoder_path, alt_model=False):
    try:
        # Load the appropriate model (either primary or alternative)
        print(">>> Using UPDATED run_predictions_in_memory")
        model = tf.keras.models.load_model(model_path)
        with open(label_encoder_path, 'rb') as f:
            label_encoder = pickle.load(f)
        model.trainable = False

        all_predictions = {}
        SEGMENT_LENGTH = 1200
        NUM_CHANNELS = 12

        for filename in sorted(os.listdir(folder_path)):
            if filename.endswith('.csv'):
                file_path = os.path.join(folder_path, filename)
                df = pd.read_csv(file_path)

                df = df.select_dtypes(include=[np.number])

                num_columns = df.shape[1]
                expected_features = SEGMENT_LENGTH * NUM_CHANNELS
                columns_to_trim = num_columns % expected_features
                if columns_to_trim != 0:
                    df = df.iloc[:, :-columns_to_trim]

                total_elements = df.shape[0] * df.shape[1]
                if total_elements % (SEGMENT_LENGTH * NUM_CHANNELS) != 0:
                    logger.warning(f"⚠ Skipping {filename} due to size mismatch.")
                    continue  # Skip bad files safely

                # Reshape EEG data
                X_temp = df.values.reshape(-1, SEGMENT_LENGTH, NUM_CHANNELS)
                X_new = np.transpose(X_temp, (0, 2, 1))
                X_new = X_new[..., np.newaxis]
                

                if alt_model:  # Alternative model (EEGNET and EEG Transformer)
                    y_pred_probs = model.predict([X_new])
                else:  # Main model (eegnet)
                    y_pred_probs = model.predict(X_new)

                # Decode predictions
                y_pred_labels = np.argmax(y_pred_probs, axis=-1)
                predicted_values = label_encoder.inverse_transform(y_pred_labels)

                all_predictions[filename] = predicted_values.tolist()

        return all_predictions

    except Exception as e:
        logger.error(f"⚠ Error in prediction: {e}")
        raise e


@lru_cache(maxsize=100)
def get_multiple_corrections(text, num_options=5):
    """Returns multiple possible corrections for the Arabic text"""
    headers = {
        "Authorization": f"Bearer {OPENROUTER_API_KEY}",
        "HTTP-Referer": "http://localhost:5000",
        "X-Title": "Arabic Text Corrector",
        "Content-Type": "application/json"
    }

    logger.debug(f"Request headers: {headers}")

    prompt = (
        "صحح هذا النص العربي وقدم {num_options} احتمالات للتصحيح مع الحفاظ على المعنى والطول. "
        "رقم كل احتمال وافصل بينهم بخط جديد بالشكل التالي:\n\n"
        "1. [النص المصحح الأول]\n"
        "2. [النص المصحح الثاني]\n"
        "وهكذا...\n\n"
        f"النص: {text}\n\n"
        "الاحتمالات:"
    ).format(num_options=num_options)

    payload = {
        "model": MODEL_NAME,
        "messages": [{"role": "user", "content": prompt}],
        "temperature": 0.7,
        "max_tokens": 300,   # Increased token limit to accommodate multiple corrections
        "n": 1               # We'll parse multiple options from a single completion
    }

    corrections = []
    
    for attempt in range(MAX_RETRIES):
        try:
            response = requests.post(
                OPENROUTER_API_URL,
                headers=headers,
                json=payload,
                timeout=15  # Increased timeout
            )

            logger.debug(f"Response status code: {response.status_code}")
            logger.debug(f"Response text: {response.text}")

            response.raise_for_status()

            # Extract the full response content
            full_content = response.json()["choices"][0]["message"]["content"]
            
            # Parse the numbered corrections
            # This regex looks for lines starting with a number followed by period and space
            correction_lines = re.findall(r'\d+\.\s+([^\n]+)', full_content)
            
            # If we didn't find structured corrections, try to split by newlines
            if not correction_lines:
                correction_lines = [line.strip() for line in full_content.split('\n') if line.strip()]
            
            # Take the first num_options corrections or all if less are available
            corrections = correction_lines[:num_options]
            
            # If we still don't have any corrections, use the full content as one option
            if not corrections:
                corrections = [full_content.strip()]
                
            return corrections

        except requests.exceptions.RequestException as e:
            logger.warning(f"Attempt {attempt + 1} failed: {str(e)}")
            if attempt == MAX_RETRIES - 1:
                return [text]  # Fallback to original text as the only option
    
    return [text]


# Global variable to store the concatenated word
concatenated_word = ""

@app.route('/start_thinking', methods=['POST'])
def start_thinking():
    global concatenated_word
    global regenerated_concatenated_word

    regenerated_concatenated_word = ""
    
    if 'file' not in request.files:
        return jsonify(error="No file provided"), 400

    file = request.files['file']
    if not file.filename.lower().endswith('.csv'):
        return jsonify(error="Only CSV files accepted"), 400

    try:
        # Step 1: Save and split the upload
        zip_data, save_path = handle_upload(file)
        app.logger.info(f"✅ Data saved to: {save_path}")

        # Store the folder path for later regeneration
        app.config['LAST_PROCESSED_PATH'] = save_path

        # Step 2: Run preprocessing notebook
        processed_folder_path = run_notebook(save_path)
        if processed_folder_path is None:
            return jsonify(error="Preprocessing failed"), 500

        # Step 3: Predict directly without saving
        predictions = run_predictions_in_memory(
            folder_path=save_path,
            model_path=MODEL_PATH,
            label_encoder_path=LABEL_ENCODER_PATH
        )


        # Debugging: Log the predictions response
        logger.debug(f"Predictions received: {json.dumps(predictions, ensure_ascii=False)}")

        # Step 4: Extract letters from predictions
        letters = []
        for key, value in predictions.items():
            if isinstance(value, list) and len(value) > 0:
                letters.append(value[0])  # Append the first letter in the list (if present)

        # Concatenate all letters into a single text string
        predicted_word = "".join(letters)

        # Step 5: Concatenate the predicted word with the previous concatenated word (if any)
        concatenated_word = f"{concatenated_word} {predicted_word}".strip() if concatenated_word else predicted_word

        # Log the concatenated word before returning (no OpenAI correction)
        logger.debug(f"Concatenated word (no correction): {concatenated_word}")

        # Step 6: Return the concatenated word (no OpenAI correction)
        return jsonify({
            "concatenated_word": concatenated_word,
            "folder_path": save_path  # Include the folder path for later regeneration
        })

    except Exception as e:
        app.logger.error(f"Processing error: {str(e)}")
        return jsonify(error="Processing failed"), 500
    



@app.route('/done_thinking', methods=['POST'])
def done_thinking():
    global concatenated_word
    global regenerated_concatenated_word
    
    try:
        if not concatenated_word:
            return jsonify(error="No concatenated sentence available. Please run 'start_thinking' first."), 400

        logger.debug(f"Concatenated sentence received for correction: {concatenated_word}")

        # Get number of correction options from request parameters (default: 5)
        num_options = request.args.get('num_options', default=5, type=int)
        
        # Get corrections
        corrected_texts = get_multiple_corrections(concatenated_word, num_options)
        

        logger.debug(f"Multiple predictions after OpenAI correction: {corrected_texts}")


        response = jsonify({
            "original_text": concatenated_word,
            "corrected_texts": corrected_texts
        })

        regenerated_concatenated_word = concatenated_word
        concatenated_word = ""
        return response

    except Exception as e:
        app.logger.error(f"Processing error: {str(e)}")
        return jsonify(error="Processing failed"), 500
    

@app.route('/restart', methods=['POST'])
def restart():
    global concatenated_word
    global regenerated_concatenated_word

    try:
        # Step 1: Reset the concatenated_word to an empty string
        concatenated_word = ""
        regenerated_concatenated_word = ""

        # Log the reset action
        logger.debug("Concatenated word has been reset.")

        # Step 2: Respond with a success message
        return jsonify({
            "message": "Server has been restarted. Concatenated word reset.",
        })

    except Exception as e:
        app.logger.error(f"Error during reset: {str(e)}")
        return jsonify(error="Failed to reset the server"), 500
    
        
@app.route('/regenerate', methods=['POST'])
def regenerate():
    """
    Regenerate the full sentence from the last N wordX folders,
    where N = number of words in concatenated_word.
    """
    global regenerated_concatenated_word
    try:
        num_options = request.args.get('num_options', default=5, type=int)
        base_path = "processed_results"

        # Get how many words are in the concatenated sentence
        num_words = len(regenerated_concatenated_word.strip().split())

        if num_words == 0:
            return jsonify(error="No concatenated sentence to match folders."), 400

        # Get all wordX folders sorted by number
        all_word_folders = sorted(
            [
                f for f in os.listdir(base_path)
                if os.path.isdir(os.path.join(base_path, f)) and f.startswith("word") and f[4:].isdigit()
            ],
            key=lambda x: int(x[4:])
        )

        if len(all_word_folders) < num_words:
            return jsonify(error="Not enough word folders to match the concatenated sentence."), 400

        # Get only the last N folders based on number of words
        word_folders = all_word_folders[-num_words:]

        logger.info(f"♻ Regenerating from folders: {word_folders}")

        full_sentence = ""
        folder_predictions = {}

        for folder in word_folders:
            folder_path = os.path.join(base_path, folder)

            predictions = run_predictions_in_memory(
                folder_path,
                ALT_MODEL_PATH,
                ALT_LABEL_ENCODER_PATH,
                alt_model=True
            )

            if not predictions:
                logger.warning(f"No predictions found in {folder_path}")
                continue

            letters = [pred[0] for pred in predictions.values() if isinstance(pred, list) and pred]
            predicted_word = "".join(letters)
            full_sentence += predicted_word + " "

            folder_predictions[folder] = predicted_word

        full_sentence = full_sentence.strip()
        logger.info(f"🧠 Reconstructed sentence: {full_sentence}")

        corrected_texts = get_multiple_corrections(full_sentence, num_options)

        return jsonify({
            "reconstructed_sentence": full_sentence,
            "corrected_texts": corrected_texts,
            "word_folders": word_folders,
            "per_folder_predictions": folder_predictions
        })

    except Exception as e:
        logger.exception("Regeneration failed.")
        return jsonify(error="Regeneration failed", message=str(e)), 500
   
# Start ngrok tunnel for external access
try:
    ngrok_tunnel = ngrok.connect(5000)
    logger.info(f"🌍 Public URL: {ngrok_tunnel.public_url}")
except Exception as e:
    logger.error(f"❌ Failed to establish ngrok tunnel: {e}")

if __name__ == '__main__':
    setup_folders()
    app.run(host='0.0.0.0', port=5000, debug=True)