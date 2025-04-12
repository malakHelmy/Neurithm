# import os
# import json
# import numpy as np
# import tensorflow as tf
# import tempfile
# import logging
# import pandas as pd
# import pickle
# from flask import Flask, request, jsonify
# from nbconvert.preprocessors import ExecutePreprocessor
# import nbformat
# from pyngrok import ngrok
# from tensorflow.keras.utils import to_categorical

# # Setup Logging
# logging.basicConfig(level=logging.DEBUG)
# logger = logging.getLogger(__name__)

# app = Flask(__name__)

# # Load trained model
# MODEL_PATH = "models/cnn_model.keras"
# try:
#     # ✅ MODIFICATION 1: Load model with compile=False to avoid TF version issues
#     model = tf.keras.models.load_model(MODEL_PATH, compile=False)
    
#     # ✅ MODIFICATION 2: Re-compile model with the same settings as training
#     model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])
    
#     # ✅ MODIFICATION 3: Print model summary to verify architecture
#     model.summary()
    
#     logger.info("✅ Model loaded successfully.")
# except Exception as e:
#     logger.error(f"❌ Error loading model: {e}")
#     raise e

# # Load Label Encoder and Convert to One-Hot Format
# LABEL_ENCODER_PATH = "models/label_encoder.pkl"
# try:
#     with open(LABEL_ENCODER_PATH, "rb") as f:
#         label_encoder = pickle.load(f)
#     num_classes = len(label_encoder.classes_)
#     logger.info(f"✅ Label Encoder loaded successfully. Total classes: {num_classes}")
#     logger.info(f"✅ Label classes: {label_encoder.classes_}")
# except Exception as e:
#     logger.error(f"❌ Error loading label encoder: {e}")
#     raise e

# # Paths
# NOTEBOOK_PATH = "notebooks/Neurithm_AR_Letters.ipynb"
# SEGMENTED_CSV_PATH = "notebooks/segmented_eeg_data.csv"

# # Function to execute the preprocessing notebook
# def run_notebook(file_path):
#     try:
#         safe_file_path = file_path.replace("\\", "/")
#         with open(NOTEBOOK_PATH, "r", encoding="utf-8") as f:
#             nb = nbformat.read(f, as_version=4)

#         # Insert the CSV path into the notebook
#         new_cell = nbformat.v4.new_code_cell(f'CSV_FILE_PATH = r"{safe_file_path}"')
#         nb.cells.insert(0, new_cell)

#         ep = ExecutePreprocessor(timeout=600, kernel_name="python3")
#         logger.info("🔄 Running Jupyter Notebook preprocessing...")

#         try:
#             ep.preprocess(nb, {"metadata": {"path": os.path.dirname(NOTEBOOK_PATH)}})
#             logger.info("✅ Notebook executed successfully.")
#         except Exception as e:
#             logger.error(f"⚠ Notebook execution error: {e}")
#             return None

#         # Ensure the segmented CSV file exists
#         if not os.path.exists(SEGMENTED_CSV_PATH):
#             logger.error(f"⚠ Segmented EEG CSV file not found: {SEGMENTED_CSV_PATH}")
#             return None

#         return SEGMENTED_CSV_PATH

#     except Exception as e:
#         logger.error(f"⚠ Critical error running notebook: {e}")
#         return None

# @app.route('/predict', methods=['POST'])
# def predict():
#     try:
#         # ✅ Step 1: Check if file is provided
#         if 'file' not in request.files:
#             return jsonify({"error": "No file provided"}), 400

#         file = request.files['file']
#         temp_csv_path = os.path.join(tempfile.gettempdir(), "temp_eeg_data.csv")
#         file.save(temp_csv_path)
#         logger.info(f"✅ CSV file saved at: {temp_csv_path}")

#         # ✅ Step 2: Run preprocessing notebook
#         processed_csv_path = run_notebook(temp_csv_path)
#         if processed_csv_path is None:
#             return jsonify({"error": "Preprocessing failed"}), 500

#         # ✅ Step 3: Load preprocessed EEG data
#         preprocessed_eeg = pd.read_csv(processed_csv_path).values
#         logger.info(f"✅ Preprocessed data shape: {preprocessed_eeg.shape}")

#         # ✅ MODIFICATION 4: Save a copy of preprocessed data for troubleshooting
#         np.savetxt("debug_preprocessed_data.csv", preprocessed_eeg, delimiter=",")
#         logger.info(f"✅ Saved copy of preprocessed data for debugging")

#         # ✅ Step 4: Ensure compatibility with model input shape
#         expected_shape = model.input_shape  # (None, segment_length, num_channels)
#         segment_length = expected_shape[1]
#         num_channels = expected_shape[2]
        
#         # ✅ Log expected shape for debugging
#         logger.info(f"✅ Expected model input shape: (batch, {segment_length}, {num_channels})")

#         # ✅ Ensure the data has the correct number of channels
#         if preprocessed_eeg.shape[1] != num_channels:
#             return jsonify({"error": f"Channel mismatch! Expected {num_channels}, got {preprocessed_eeg.shape[1]}"}), 500

#         # ✅ Step 5: Dynamic Reshaping
#         total_samples = preprocessed_eeg.shape[0]
#         num_segments = total_samples // segment_length

#         if num_segments == 0:
#             return jsonify({"error": "Not enough data to form a full segment"}), 400

#         # Trim to full segments only
#         valid_samples = num_segments * segment_length
#         preprocessed_eeg = preprocessed_eeg[:valid_samples]
        
#         # ✅ MODIFICATION 5: Ensure proper data type matching training
#         preprocessed_eeg = preprocessed_eeg.astype(np.float32)
        
#         preprocessed_eeg = np.reshape(preprocessed_eeg, (num_segments, segment_length, num_channels))
#         logger.info(f"✅ Preprocessed data reshaped to: {preprocessed_eeg.shape}")

#         # ✅ Step 6: Run model prediction
#         try:
#             # ✅ MODIFICATION 6: Remove temperature scaling - use raw predictions
#             predictions = model.predict(preprocessed_eeg)
            
#             # ✅ MODIFICATION 7: Add confidence values to output
#             confidence_scores = np.max(predictions, axis=-1)
#             logger.info(f"Confidence scores: {confidence_scores}")
            
#         except Exception as prediction_error:
#             logger.error(f"❌ Prediction failed: {prediction_error}")
#             return jsonify({"error": f"Prediction failed: {str(prediction_error)}"}), 500

#         # ✅ Step 7: Convert Predictions to Arabic Letters
#         logger.info(f"✅ Label Encoder Classes: {label_encoder.classes_}")

#         # Debug: Print model raw outputs
#         logger.info(f"Raw Model Predictions (first 5 rows): {predictions[:5]}")

#         # ✅ MODIFICATION 8: Add more detailed logging of predictions
#         for i in range(min(5, len(predictions))):
#             top_indices = np.argsort(predictions[i])[-3:][::-1]  # Top 3 predictions
#             top_letters = [label_encoder.classes_[idx] for idx in top_indices]
#             top_probs = [predictions[i][idx] for idx in top_indices]
#             logger.info(f"Segment {i+1} - Top 3 predictions: {list(zip(top_letters, top_probs))}")

#         # Convert from one-hot encoding
#         predicted_indices = np.argmax(predictions, axis=-1)
#         predicted_letters = [label_encoder.classes_[idx] for idx in predicted_indices]

#         logger.info(f"✅ Final Predictions: {predicted_letters}")
        
#         # ✅ MODIFICATION 9: Check for prediction consistency
#         most_frequent_letter = max(set(predicted_letters), key=predicted_letters.count)
#         consistency = predicted_letters.count(most_frequent_letter) / len(predicted_letters)
#         logger.info(f"✅ Prediction consistency: {consistency:.2f} - Most frequent: {most_frequent_letter}")

#         # ✅ MODIFICATION 10: Include consistency information in the response
#         response = {
#             "predictions": predicted_letters,
#             "most_frequent": most_frequent_letter,
#             "consistency": float(consistency),
#             "confidence_scores": confidence_scores.tolist()
#         }

#         return json.dumps(response, ensure_ascii=False)

#     except Exception as e:
#         logger.error(f"❌ Unexpected Error: {e}")
#         return jsonify({"error": str(e)}), 500

# # Start ngrok tunnel for external access
# try:
#     ngrok_tunnel = ngrok.connect(5000)
#     logger.info(f"🌍 Public URL: {ngrok_tunnel.public_url}")
# except Exception as e:
#     logger.error(f"❌ Failed to establish ngrok tunnel: {e}")

# if __name__ == '__main__':
#     app.run(debug=False, port=5000)

from flask import Flask, request, jsonify, send_file
import io
import zipfile
import pandas as pd
import numpy as np
import os
from pathlib import Path

app = Flask(__name__)

# Configuration
OUTPUT_DIR = Path("processed_results")  

def setup_folders():
    """Ensure output directory exists"""
    OUTPUT_DIR.mkdir(exist_ok=True)

def get_next_word_id():
    """Get next sequential word ID (1, 2, 3...)"""
    existing = [int(f.name[7:]) for f in OUTPUT_DIR.glob("word*") if f.is_dir() and f.name[7:].isdigit()]
    return max(existing) + 1 if existing else 1

def process_eeg_data(df, sample_rate=128, letter_duration=10, gap=1):
    """Split EEG data into letter segments"""
    rows_per_letter = sample_rate * letter_duration
    rows_per_gap = sample_rate * gap
    segments = []
    
    for start in range(0, len(df), rows_per_letter + rows_per_gap):
        end = min(start + rows_per_letter, len(df))
        segments.append(df.iloc[start:end].copy())
    
    return segments

def handle_upload(file):
    """Process uploaded file and return zip buffer with session info"""
    setup_folders()
    word_id = get_next_word_id()
    word_path = OUTPUT_DIR / f"word{word_id}"
    word_path.mkdir()

    # Read and clean data
    df = pd.read_csv(file)
    df.replace([np.nan, 'nan', 'NaN'], np.nan, inplace=True)
    
    # Process and save
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

@app.route('/predict', methods=['POST'])
def handle_request():
    if 'file' not in request.files:
        return jsonify(error="No file provided"), 400
    
    file = request.files['file']
    if not file.filename.lower().endswith('.csv'):
        return jsonify(error="Only CSV files accepted"), 400
    
    try:
        zip_data, save_path = handle_upload(file)
        app.logger.info(f"Data saved to: {save_path}")
        return send_file(
            zip_data,
            mimetype='application/zip',
            as_attachment=True,
            download_name="eeg_results.zip"
        )
    except Exception as e:
        app.logger.error(f"Processing error: {str(e)}")
        return jsonify(error="Processing failed"), 500

if __name__ == '__main__':
    setup_folders()
    app.run(host='0.0.0.0', port=5000, debug=True)