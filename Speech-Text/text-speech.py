import os
import requests  # Import requests to send HTTP requests to app.py
from google.cloud import texttospeech_v1

# Set up the Google Cloud Text-to-Speech client
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = 'key.json'
client = texttospeech_v1.TextToSpeechClient()

# URL of the app.py Flask server (running locally)
last_translation_url = 'http://127.0.0.1:5000/last-translation'

# Fetch the last Spanish and Tzotzil translation from app.py
response = requests.get(last_translation_url)

# Check if the request was successful
if response.status_code == 200:
    # Extract the Tzotzil translation from the response
    translation_data = response.json()
    tzotzil_translation = translation_data.get("tzotzil_text")
    print(f"Last translation received: {tzotzil_translation}")
else:
    print(f"Error: Unable to fetch the last translation. Status code: {response.status_code}")
    tzotzil_translation = "Translation not available"

# Prepare the text for text-to-speech conversion using the Tzotzil translation
synthesis_input = texttospeech_v1.SynthesisInput(text=tzotzil_translation)

# Voice configuration
voice2 = texttospeech_v1.VoiceSelectionParams(
    name='es-ES-Standard-B',
    language_code='es-ES'
)

audio_config = texttospeech_v1.AudioConfig(
    audio_encoding=texttospeech_v1.AudioEncoding.MP3
)

# Perform text-to-speech conversion
response1 = client.synthesize_speech(
    input=synthesis_input,
    voice=voice2,
    audio_config=audio_config
)

# Write the audio output to a file
with open('audio.mp3', 'wb') as output:
    output.write(response1.audio_content)

print(f"Audio content written to 'audio.mp3' for translation: {tzotzil_translation}")
