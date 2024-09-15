import os
from unicodedata import name
from urllib import response
from google.cloud import texttospeech_v1

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = 'key.json'
client = texttospeech_v1.TextToSpeechClient()

text = 'Poty es una verga'

synthesis_input = texttospeech_v1.SynthesisInput(text=text)

voice1 = texttospeech_v1.VoiceSelectionParams(
    language_code = 'es-ES',
    ssml_gender = texttospeech_v1.SsmlVoiceGender.MALE
)
voice2 = texttospeech_v1.VoiceSelectionParams(
    name = 'es-ES-Standard-B',
    language_code = 'es-ES'
)

print(client.list_voices)
audio_config = texttospeech_v1.AudioConfig(
    audio_encoding = texttospeech_v1.AudioEncoding.MP3
)

response1 = client.synthesize_speech(
    input = synthesis_input,
    voice = voice2,
    audio_config = audio_config
)

with open('audio.mp3', 'wb',) as output:
    output.write(response1.audio_content)
