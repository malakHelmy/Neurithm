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

# Setup Logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

app = Flask(__name__)

# Constants
NOTEBOOK_PATH = "notebooks/Letters_notebook_file_by_file.ipynb"
MODEL_PATH = "models/eegnet_model_letters 79.63.keras"
LABEL_ENCODER_PATH = "models/label_encoder_eegnet_letters 79.63.pkl"
OUTPUT_DIR = Path("processed_results")

# Load model once
try:
    model = tf.keras.models.load_model(MODEL_PATH)
    logger.info("✅ Model loaded successfully.")
except Exception as e:
    logger.error(f"❌ Error loading model: {e}")
    raise e

# Load label encoder once
try:
    with open(LABEL_ENCODER_PATH, "rb") as f:
        label_encoder = pickle.load(f)
    num_classes = len(label_encoder.classes_)
    logger.info(f"✅ Label Encoder loaded successfully. Total classes: {num_classes}")
except Exception as e:
    logger.error(f"❌ Error loading label encoder: {e}")
    raise e


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

        # Step 4: Return predictions in HTTP response
        return Response(
            json.dumps(predictions, ensure_ascii=False),
            mimetype='application/json'
        )

    except Exception as e:
        app.logger.error(f"Processing error: {str(e)}")
        return jsonify(error="Processing failed"), 500

if __name__ == '__main__':
    setup_folders()
    app.run(host='0.0.0.0', port=5000, debug=True)
