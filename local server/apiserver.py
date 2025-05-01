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
from scipy import signal
from sklearn.preprocessing import StandardScaler
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
MODEL_PATH = "models/eegnet_model_letters 81.31.keras"
LABEL_ENCODER_PATH = "models/label_encoder_eegnet_letters 81.31.pkl"
# Add path for the alternative model
ALT_MODEL_PATH = "models/without_pos_encoding.keras"
ALT_LABEL_ENCODER_PATH = "models/without_pos_encoding.pkl"
OUTPUT_DIR = Path("processed_results")

# Access the API key from the environment
OPENROUTER_API_KEY = OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY")
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

def inner_positional_encoding(seq_length, d_model):
    """Generate fixed sinusoidal positional encodings"""
    positions = np.arange(seq_length)[:, np.newaxis]
    depths = np.arange(d_model)[np.newaxis, :] / d_model
    angle_rates = 1 / (10000**depths)
    angle_rads = positions * angle_rates
    pos_encoding = np.zeros(angle_rads.shape)
    pos_encoding[:, 0::2] = np.sin(angle_rads[:, 0::2])
    pos_encoding[:, 1::2] = np.cos(angle_rads[:, 1::2])
    return tf.cast(pos_encoding, dtype=tf.float32)

@register_keras_serializable('add_positional_encoding')
def add_positional_encoding(x):
    w, h, c = x.shape
    return x + inner_positional_encoding(w, h * c)


# Load primary model once
try:
    model = tf.keras.models.load_model(MODEL_PATH, custom_objects={'add_positional_encoding': add_positional_encoding})
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

# Load alternative model once
try:
    alt_model = tf.keras.models.load_model(ALT_MODEL_PATH, custom_objects={'add_positional_encoding': add_positional_encoding})
    logger.info("✅ Alternative model (EEGTransformer) loaded successfully.")
except Exception as e:
    logger.error(f"❌ Error loading alternative model: {e}")
    logger.warning("Will attempt to load on demand when needed.")
    alt_model = None

# Load alternative label encoder once
try:
    with open(ALT_LABEL_ENCODER_PATH, "rb") as f:
        alt_label_encoder = pickle.load(f)
    alt_num_classes = len(alt_label_encoder.classes_)
    logger.info(f"✅ Alternative label encoder loaded successfully. Total classes: {alt_num_classes}")
except Exception as e:
    logger.error(f"❌ Error loading alternative label encoder: {e}")
    logger.warning("Will attempt to load on demand when needed.")
    alt_label_encoder = None

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


def run_predictions_in_memory(folder_path, model_path, label_encoder_path):
    """Predict on preprocessed EEG segments directly in memory"""
    try:
        # Load model and label encoder again (optional, or reuse already loaded ones)
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

                # Reshape
                X_temp = df.values.reshape(-1, SEGMENT_LENGTH, NUM_CHANNELS)
                X_new = np.transpose(X_temp, (0, 2, 1))
                X_new = X_new[..., np.newaxis]

                # Predict
                y_pred_probs = model.predict(X_new)
                y_pred_labels = np.argmax(y_pred_probs, axis=-1)
                predicted_values = label_encoder.inverse_transform(y_pred_labels)

                all_predictions[filename] = predicted_values.tolist()

        return all_predictions

    except Exception as e:
        logger.error(f"⚠ Error in prediction: {e}")
        raise e

def generate_positional_encoding(seq_len, depth):
    """Generate fixed sinusoidal positional encodings"""
    positions = np.arange(seq_len)[:, np.newaxis]
    depths = np.arange(depth)[np.newaxis, :] / depth
    angle_rates = 1 / (10000**depths)
    angle_rads = positions * angle_rates

    pos_encoding = np.zeros(angle_rads.shape)
    pos_encoding[:, 0::2] = np.sin(angle_rads[:, 0::2])
    pos_encoding[:, 1::2] = np.cos(angle_rads[:, 1::2])

    return tf.cast(pos_encoding, dtype=tf.float32)

def add_noise(signal, noise_level=0.05):
    noise = np.random.normal(0, noise_level, signal.shape)
    return signal + noise

def time_shift(signal, shift_max=50):
    shift = np.random.randint(-shift_max, shift_max)
    return np.roll(signal, shift, axis=0)

def scale_amplitude(signal, scale_range=(0.8, 1.2)):
    scale = np.random.uniform(scale_range[0], scale_range[1])
    return signal * scale

def frequency_mask(signal, mask_fraction=0.1):
    signal_shape = signal.shape
    signal_flat = signal.reshape(-1, signal_shape[-1])

    for i in range(signal_flat.shape[0]):
        sig = signal_flat[i]
        sig_fft = np.fft.rfft(sig)
        num_freqs = len(sig_fft)
        num_masked = int(mask_fraction * num_freqs)
        if num_masked > 0:
            mask_idx = np.random.choice(num_freqs, num_masked, replace=False)
            sig_fft[mask_idx] = 0
        signal_flat[i] = np.fft.irfft(sig_fft, len(sig))

    return signal_flat.reshape(signal_shape)

def contrast_enhancement(signal, factor_range=(0.8, 1.5)):
    factor = np.random.uniform(factor_range[0], factor_range[1])
    mean = np.mean(signal)
    return (signal - mean) * factor + mean

def advanced_augmentation(segments, aug_intensity=0.8):
    augmented = segments.copy()
    batch_size = segments.shape[0]

    noise_mask = np.random.random(batch_size) < aug_intensity
    shift_mask = np.random.random(batch_size) < aug_intensity * 0.8
    scale_mask = np.random.random(batch_size) < aug_intensity * 0.7
    freq_mask = np.random.random(batch_size) < aug_intensity * 0.6
    contrast_mask = np.random.random(batch_size) < aug_intensity * 0.5

    if np.any(noise_mask):
        noise_levels = np.random.uniform(0.01, 0.05, batch_size)
        for i in np.where(noise_mask)[0]:
            augmented[i] = add_noise(segments[i], noise_level=noise_levels[i])

    if np.any(shift_mask):
        shift_values = np.random.randint(-20, 20, batch_size)
        for i in np.where(shift_mask)[0]:
            augmented[i] = np.roll(segments[i], shift_values[i], axis=1)

    if np.any(scale_mask):
        scale_values = np.random.uniform(0.85, 1.15, batch_size)
        for i in np.where(scale_mask)[0]:
            augmented[i] = segments[i] * scale_values[i]

    if np.any(freq_mask):
        mask_fractions = np.random.uniform(0.05, 0.15, batch_size)
        for i in np.where(freq_mask)[0]:
            augmented[i] = frequency_mask(segments[i], mask_fraction=mask_fractions[i])

    if np.any(contrast_mask):
        factor_ranges = [(0.9, 1.3) for _ in range(batch_size)]
        for i in np.where(contrast_mask)[0]:
            augmented[i] = contrast_enhancement(segments[i], factor_range=factor_ranges[i])

    return augmented

def extract_frequency_features(X, fs=250):
    bands = {
        'delta': (0.5, 4), 'theta': (4, 8), 'alpha': (8, 13),
        'beta': (13, 30), 'gamma': (30, 50)
    }

    batch_size, channels, samples, _ = X.shape
    X_freq = np.zeros((batch_size, channels, len(bands)))

    for i in range(batch_size):
        for c in range(channels):
            signal_data = X[i, c, :, 0]
            freqs, psd = signal.welch(signal_data, fs=fs, nperseg=min(256, len(signal_data)))
            for j, (band_name, (low, high)) in enumerate(bands.items()):
                idx_band = np.logical_and(freqs >= low, freqs <= high)
                if np.any(idx_band):
                    X_freq[i, c, j] = np.mean(psd[idx_band])

    X_freq_reshaped = X_freq.reshape(batch_size, -1)
    scaler = StandardScaler()
    X_freq_normalized = scaler.fit_transform(X_freq_reshaped)

    return X_freq_normalized.reshape(batch_size, channels, len(bands))

# Main prediction function
def run_transformer_predictions(folder_path):
    """Run predictions with the alternative EEGTransformer model"""
    try:
        global alt_model, alt_label_encoder

        if alt_model is None:
            alt_model = tf.keras.models.load_model(ALT_MODEL_PATH)
            logger.info("✅ Alternative model loaded on demand.")

        if alt_label_encoder is None:
            with open(ALT_LABEL_ENCODER_PATH, "rb") as f:
                alt_label_encoder = pickle.load(f)
            logger.info("✅ Alternative label encoder loaded on demand.")

        alt_model.trainable = False

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
                X_new = np.transpose(X_temp, (0, 2, 1))  # Shape: (samples, channels, time_steps)
                X_new = X_new[..., np.newaxis]  # Adding the last dimension (shape: (samples, channels, time_steps, 1))

                # Debugging: Log the shape of reshaped data
                logger.debug(f"X_new shape: {X_new.shape}")

                # Apply augmentations (same as in training)
                X_new_augmented = advanced_augmentation(X_new, aug_intensity=0.8)

                # Debugging: Log augmented data shape
                logger.debug(f"X_new_augmented shape: {X_new_augmented.shape}")

                # Feature extraction
                X_new_freq = extract_frequency_features(X_new_augmented)

                # Debugging: Log frequency features shape
                logger.debug(f"X_new_freq shape: {X_new_freq.shape}")

                # Generate positional encoding for the second input
                batch_size = X_new.shape[0]
                seq_len = 12  # Expected sequence length (time steps)
                embedding_dim = 5  # Expected dimensions for the second input (positional encoding)
                X_input2 = generate_positional_encoding(seq_len, embedding_dim)  # Generate positional encoding for the second input

                # Repeat the positional encoding for the batch size (to match X_new shape)
                X_input2 = tf.repeat(X_input2[tf.newaxis, :, :], batch_size, axis=0)  # Shape: (batch_size, seq_len, embedding_dim)

                # Debugging: Log positional encoding shape
                logger.debug(f"X_input2 shape: {X_input2.shape}")

                # Run prediction with both inputs
                y_pred_probs = alt_model.predict([X_new_augmented, X_input2])
                y_pred_labels = np.argmax(y_pred_probs, axis=-1)
                predicted_values = alt_label_encoder.inverse_transform(y_pred_labels)

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


# Global variable to store the concatenated word
concatenated_word = ""

@app.route('/start_thinking', methods=['POST'])
def start_thinking():
    global concatenated_word  # Use the global variable to store the concatenated word

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

        # Step 3: Predict directly without OpenAI correction
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
    global concatenated_word  # Declare global variable before using it
    
    try:
        # Check if the concatenated_word exists (i.e., not empty)
        if not concatenated_word:
            return jsonify(error="No concatenated word available. Please run 'start_thinking' first."), 400

        # Log the concatenated text received
        logger.debug(f"Concatenated text received for correction: {concatenated_word}")

        # Step 2: Get multiple possible corrections via OpenAI (using OpenRouter API)
        num_options = request.args.get('num_options', default=5, type=int)
        corrected_texts = get_multiple_corrections(concatenated_word, num_options)

        # Log the corrected texts
        logger.debug(f"Multiple predictions after OpenAI correction: {corrected_texts}")

        # Step 3: Return the original and corrected texts in HTTP response
        response = jsonify({
            "original_text": concatenated_word,  # Concatenated word sent in response
            "corrected_texts": corrected_texts
        })

        # Step 4: Reset the concatenated_word after processing
        concatenated_word = ""  # Reset the concatenated word to empty

        return response

    except Exception as e:
        app.logger.error(f"Processing error: {str(e)}")
        return jsonify(error="Processing failed"), 500

@app.route('/restart', methods=['POST'])
def restart():
    global concatenated_word  # Declare the global variable

    try:
        # Step 1: Reset the concatenated_word to an empty string
        concatenated_word = ""  # Clear the concatenated word

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
    """Regenerate predictions for a specific preprocessed word folder using the EEGTransformer model"""
    try:
        data = request.json
        word_folder = data.get('word_folder')
        num_options = data.get('num_options', 5)

        if not word_folder:
            return jsonify(error="Missing 'word_folder' in request."), 400

        # Updated base path
        base_path = "processed_results"
        full_path = os.path.join(base_path, word_folder)

        if not os.path.exists(full_path):
            return jsonify(error=f"Folder '{full_path}' not found."), 404

        logger.info(f"♻ Regenerating predictions from folder: {full_path}")

        # Run predictions using the alternate model
        predictions = run_transformer_predictions(full_path)

        logger.debug(f"EEGTransformer predictions: {json.dumps(predictions, ensure_ascii=False)}")

        # Extract predicted letters (1st prediction per file)
        letters = [pred[0] for pred in predictions.values() if isinstance(pred, list) and pred]
        predicted_sequence = "".join(letters)
        logger.info(f"Predicted letter sequence: {predicted_sequence}")

        # Get corrected full-text options
        corrected_texts = get_multiple_corrections(predicted_sequence, num_options)

        return jsonify({
            "regenerated_text": predicted_sequence,
            "corrected_texts": corrected_texts,
            "folder_path": full_path
        })

    except Exception as e:
        logger.exception("Regeneration failed.")
        return jsonify(error="Regeneration failed", message=str(e)), 500




   
# # Start ngrok tunnel for external access
# try:
#     ngrok_tunnel = ngrok.connect(5000)
#     logger.info(f"🌍 Public URL: {ngrok_tunnel.public_url}")
# except Exception as e:
#     logger.error(f"❌ Failed to establish ngrok tunnel: {e}")

if __name__ == '__main__':
    setup_folders()
    app.run(host='0.0.0.0', port=5000, debug=True)
