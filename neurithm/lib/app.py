from flask import Flask, request, jsonify, send_file
from TTS.api import TTS
from pydub import AudioSegment
import os
import logging
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Set up logging
logging.basicConfig(level=logging.DEBUG)

# Load the XTTS-v2 model
tts = TTS("tts_models/multilingual/multi-dataset/xtts_v2", gpu=False)  # Set gpu=True if you have a GPU
print("XTTS-v2 model loaded successfully.")

# Path to the reference speaker audio file
SPEAKER_WAV_PATH = "output.wav"  # Update this path

@app.route('/synthesize', methods=['POST'])
def synthesize():
    data = request.json
    text = data.get("text", "Hello, this is a test.")
    pitch = float(data.get("pitch", 1.0))  # Default pitch
    language = data.get("language", "en")  # Default language (supports "en" and "ar")
    output_wav = "output.wav"

    # Generate audio with XTTS-v2
    tts.tts_to_file(
        text=text,
        file_path=output_wav,
        speaker_wav=SPEAKER_WAV_PATH,  # Use the valid reference speaker audio file
        language=language  # Specify language ("en" for English, "ar" for Arabic)
    )

    # Adjust pitch using pydub
    audio = AudioSegment.from_file(output_wav)
    adjusted_audio = audio._spawn(audio.raw_data, overrides={
        "frame_rate": int(audio.frame_rate * pitch)
    }).set_frame_rate(audio.frame_rate)

    # Save the adjusted audio
    adjusted_output_wav = "adjusted_output.wav"
    adjusted_audio.export(adjusted_output_wav, format="wav")

    return send_file(adjusted_output_wav, as_attachment=True)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)