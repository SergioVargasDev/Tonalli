from flask import Flask, request, jsonify

app = Flask(__name__)

# Hardcoded Spanish to Tzotzil dictionary
spanish_to_tzotzil = {
    "hola": "k´ux",
    "como te llamas": "k'usi mi a?at",
    "trabajo": "abtel",
    "adios": "bix a",
    # Add more translations here...
}

# Translation route
@app.route('/translate', methods=['POST'])
def translate():
    # Extract JSON data
    data = request.get_json()

    # Log the incoming request data
    print(f"Incoming request data: {data}")

    # Extract Spanish text from the request, defaulting to an empty string if not found
    spanish_text = data.get("text", "").lower()

    # Translate to Tzotzil using the hardcoded dictionary
    tzotzil_translation = spanish_to_tzotzil.get(spanish_text, "Translation not available")

    # Log the translation result
    print(f"Translated '{spanish_text}' to '{tzotzil_translation}'")

    # Return the Tzotzil translation in a JSON response
    response = jsonify({"tzotzil_text": tzotzil_translation})

    # Log the response being sent back
    print(f"Response: {response.get_json()}")

    return response

if __name__ == '__main__':
    app.run(debug=True)
