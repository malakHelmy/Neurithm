import logging
import os
import requests
from flask import Flask, request, jsonify
from functools import lru_cache

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

# OpenRouter Configuration
OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY", "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")
OPENROUTER_API_URL = "https://openrouter.ai/api/v1/chat/completions"
MODEL_NAME = "deepseek/deepseek-chat-v3-0324"
MAX_RETRIES = 3

@lru_cache(maxsize=100)
def correct_via_api(text):
    """Returns ONLY the corrected Arabic text"""
    headers = {
        "Authorization": f"Bearer {OPENROUTER_API_KEY}",
        "HTTP-Referer": "http://localhost:5000",
        "X-Title": "Arabic Text Corrector",
        "Content-Type": "application/json"
    }
    
    prompt = (
        "صحح هذا النص العربي مع الحفاظ على المعنى والطول. "
        "أرجع النص المصحح فقط بدون أي شرح أو تعليقات.\n\n"
        f"النص: {text}\n\n"
        "النص المصحح:"
    )
    
    payload = {
        "model": MODEL_NAME,
        "messages": [{"role": "user", "content": prompt}],
        "temperature": 0.1,
        "max_tokens": 100
    }
    
    for attempt in range(MAX_RETRIES):
        try:
            response = requests.post(
                OPENROUTER_API_URL,
                headers=headers,
                json=payload,
                timeout=10
            )
            response.raise_for_status()
            
            # Extract and return ONLY the corrected text
            corrected = response.json()["choices"][0]["message"]["content"]
            return corrected.strip()
            
        except requests.exceptions.RequestException as e:
            logger.warning(f"Attempt {attempt + 1} failed: {str(e)}")
            if attempt == MAX_RETRIES - 1:
                return text  # Fallback to original

@app.route('/generatecontext', methods=['POST'])
def correct_text():
    try:
        data = request.get_json()
        if not data or 'text' not in data:
            return jsonify({"error": "Missing 'text' parameter"}), 400
            
        original_text = str(data['text']).strip()
        if not original_text:
            return jsonify({"error": "Empty text provided"}), 400

        corrected_text = correct_via_api(original_text)
        return corrected_text  # Returns plain text response (not JSON)
        
    except Exception as e:
        logger.error(f"Error: {str(e)}")
        return "Error processing request", 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)