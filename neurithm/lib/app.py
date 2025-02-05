from flask import Flask, request, jsonify, send_file
from TTS.api import TTS
import os
import logging
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Enable CORS

# Set up logging
logging.basicConfig(level=logging.DEBUG)

# Load the Coqui TTS model
tts = TTS("tts_models/en/ljspeech/glow-tts").to("cpu")

@app.route('/synthesize', methods=['POST'])
def synthesize():
    data = request.json
    text = data.get("text", "Hello, this is a test.")
    output_wav = "output.wav"  # Define the output file name
    tts.tts_to_file(text=text, file_path=output_wav)

    # Verify the file exists
    if os.path.exists(output_wav):
        app.logger.debug(f"Audio file generated: {output_wav}")  # Use the variable `output_wav`
        return send_file(output_wav, as_attachment=True)
    else:
        app.logger.error("Failed to generate audio file.")
        return jsonify({"error": "Failed to generate audio file."}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)