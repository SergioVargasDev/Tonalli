import json
from google.cloud import speech

# Crear el cliente de Google Cloud Speech
client = speech.SpeechClient.from_service_account_file('key.json')

# Leer el archivo MP3
file_name = 'test.mp3'
with open(file_name, 'rb') as f:
    mp3_data = f.read()

# Configurar el archivo de audio y las opciones de reconocimiento
audio_file = speech.RecognitionAudio(content=mp3_data)
config = speech.RecognitionConfig(
    sample_rate_hertz=44100,
    enable_automatic_punctuation=True,
    language_code='es-MX'
)

# Realizar el reconocimiento
response = client.recognize(
    config=config,
    audio=audio_file
)

# Extraer el texto reconocido y construir el JSON
for result in response.results:
    transcript = result.alternatives[0].transcript
    json_response = json.dumps({"text": transcript})
    print(json_response)