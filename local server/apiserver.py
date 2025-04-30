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
MODEL_PATH = "models/eegnet_model_letters 79.63.keras"
LABEL_ENCODER_PATH = "models/label_encoder_eegnet_letters 79.63.pkl"
# Add path for the alternative model
ALT_MODEL_PATH = "models/wout.keras"
ALT_LABEL_ENCODER_PATH = "models/wout.pkl"
OUTPUT_DIR = Path("processed_results")

# Access the API key from the environment
OPENROUTER_API_KEY = "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"
OPENROUTER_API_URL = "https://openrouter.ai/api/v1/chat/completions"
MODEL_NAME = "deepseek/deepseek-chat-v3-0324"
MAX_RETRIES = 3

# You can now use OPENROUTER_API_KEY safely
print(f"Your OpenRouter API Key is: {OPENROUTER_API_KEY}")
# Custom Layer for Positional Encoding
import numpy as np
import tensorflow as tf
from tensorflow.keras.layers import Lambda
from tensorflow.keras.utils import register_keras_serializable
import traceback

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


# Load alternative model (Transformer)
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
        # For the last segment, avoid adding a gap after it
        if start + rows_per_letter + rows_per_gap > len(df):
            end = min(start + rows_per_letter, len(df))
        else:
            end = min(start + rows_per_letter, len(df))
        
        # Add the segment to the list
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

    # Create in-memory zip (optional - you don't use it now)
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

def run_predictions_in_memory(folder_path, model, label_encoder):
    predictions = {}

    for csv_file in sorted(Path(folder_path).glob("letter_*.csv")):
        df = pd.read_csv(csv_file)

        # Keep only numeric values
        df = df.select_dtypes(include=[np.number]).fillna(0).astype(np.float32)

        if df.empty:
            logger.warning(f"⚠ Skipping {csv_file.name} — empty or non-numeric.")
            continue

        try:
            # Reshape EEG input: (1, 12, 1200, 1)
            eeg_data = df.values.reshape((1, 12, 1200, 1))

            # Generate dummy context data: (1, 12, 5)
            # Adjust this if you have real context values to use
            context_data = np.zeros((1, 12, 5), dtype=np.float32)

            # Run prediction
            pred = model.predict([eeg_data, context_data])
            class_idx = np.argmax(pred, axis=-1)
            letter = label_encoder.inverse_transform(class_idx)[0]
            predictions[csv_file.stem] = [letter]

        except Exception as e:
            logger.warning(f"⚠ Failed to process {csv_file.name}: {str(e)}")

    return predictions




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
        "temperature": 0.7,  # Increased temperature for more variety
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
    
    return [text]  # Fallback if all else fails


@app.route('/predict', methods=['POST'])
def handle_request():
    if 'file' not in request.files:
        return jsonify(error="No file provided"), 400

    file = request.files['file']
    if not file.filename.lower().endswith('.csv'):
        return jsonify(error="Only CSV files accepted"), 400

    try:
        # Step 1: Save and split the upload
        zip_data, save_path = handle_upload(file)
        app.logger.info(f"✅ Data saved to: {save_path}")

        # Store the folder path in the session or a global variable
        # so we can reuse it for regeneration
        app.config['LAST_PROCESSED_PATH'] = save_path

        # Step 2: Run preprocessing notebook
        processed_folder_path = run_notebook(save_path)
        if processed_folder_path is None:
            return jsonify(error="Preprocessing failed"), 500

        # Step 3: Predict directly without saving
        # ✅ Correct: Pass the paths
        predictions = run_predictions_in_memory(
            folder_path=save_path,
            model_path=ALT_MODEL_PATH,
            label_encoder_path=ALT_LABEL_ENCODER_PATH
        )


        # Debugging: Log the predictions response
        logger.debug(f"Predictions received: {json.dumps(predictions, ensure_ascii=False)}")

        # Step 4: Extract letters from predictions
        letters = []
        for key, value in predictions.items():
            if isinstance(value, list) and len(value) > 0:
                letters.append(value[0])  # Append the first letter in the list (if present)

        # Concatenate all letters into a single text string
        predictions_text = "".join(letters)

        # Log the predictions text before correction
        logger.debug(f"Predictions before correction: {predictions_text}")

        # Step 5: Get multiple possible corrections via the API (default is 5)
        num_options = request.args.get('num_options', default=5, type=int)
        corrected_texts = get_multiple_corrections(predictions_text, num_options)

        # Log the corrected texts
        logger.debug(f"Multiple predictions after correction: {corrected_texts}")

        # Step 6: Return the corrected texts in HTTP response
        return Response(
            json.dumps({
                "original_text": predictions_text,
                "corrected_texts": corrected_texts,
                "folder_path": save_path  # Include the folder path for later regeneration
            }, ensure_ascii=False),
            mimetype='application/json'
        )

    except Exception as e:
        app.logger.error(f"Processing error: {str(e)}")
        return jsonify(error="Processing failed"), 500


@app.route('/predict-alt', methods=['POST'])
def handle_alt_prediction():
    if 'file' not in request.files:
        return jsonify(error="No file provided"), 400

    file = request.files['file']
    if not file.filename.lower().endswith('.csv'):
        return jsonify(error="Only CSV files accepted"), 400

    try:
        # Step 1: Save and segment
        zip_data, save_path = handle_upload(file)
        logger.info(f"✅ Alt model input saved to: {save_path}")

        # Step 2: Preprocess with notebook
        processed_folder_path = run_notebook(save_path)
        if processed_folder_path is None:
            return jsonify(error="Preprocessing failed"), 500

        # Step 3: Run predictions using the alt model
        predictions = run_predictions_in_memory(
            folder_path=save_path,
            model=alt_model,
            label_encoder=alt_label_encoder
        )

        # Step 4: Assemble letters
        letters = []
        for key, value in sorted(predictions.items()):
            if isinstance(value, list) and len(value) > 0:
                letters.append(value[0])

        predictions_text = "".join(letters)
        logger.debug(f"🧠 Alt model prediction: {predictions_text}")

        # Step 5: Correct the prediction
        num_options = request.args.get('num_options', default=5, type=int)
        corrected_texts = get_multiple_corrections(predictions_text, num_options)

        return Response(
            json.dumps({
                "original_text": predictions_text,
                "corrected_texts": corrected_texts,
                "folder_path": save_path
            }, ensure_ascii=False),
            mimetype='application/json'
        )

    except Exception as e:
        logger.error(f"Alt model processing failed: {str(e)}")
        traceback.print_exc()
        return jsonify(error="Alt model processing failed"), 500


# # Start ngrok tunnel for external access
# try:
#     ngrok_tunnel = ngrok.connect(5000)
#     logger.info(f"🌍 Public URL: {ngrok_tunnel.public_url}")
# except Exception as e:
#     logger.error(f"❌ Failed to establish ngrok tunnel: {e}")

if __name__ == '__main__':
    setup_folders()
    app.run(host='0.0.0.0', port=5000, debug=True)