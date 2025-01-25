from flask import Flask, request, jsonify
from TTS.api import TTS
import io

app = Flask(__name__)

# Initialize the TTS model (Use a pre-trained model or download one)
tts = TTS(model_name="tts_models/en/ljspeech/tacotron2-DDC", gpu=False)

@app.route("/api/tts", methods=["POST"])
def synthesize_speech():
    try:
        data = request.json
        text = data['text']
        pitch = data.get('pitch', 1.0)
        speed = data.get('speed', 1.0)

        # Generate speech audio
        audio_data = tts.tts(text)
        audio_io = io.BytesIO(audio_data)

        return audio_io.getvalue(), 200, {'Content-Type': 'audio/wav'}

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True, port=5002)
