import requests

url = 'http://127.0.0.1:5000/translate'
data = {'text': 'hola'}

response = requests.post(url, json=data)
print(response.json())
