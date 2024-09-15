from flask import Flask, request, jsonify

app = Flask(__name__)

# Hardcoded Spanish to Tzotzil dictionary
spanish_to_tzotzil = {
    "hola": "k´ux",
    "como te llamas": "k'usi mi a?at",
    "trabajo": "abtel",
    "adios": "bix a",
}

# Variable to store the last Spanish text and its translation
last_spanish_text = None
last_tzotzil_translation = None

def get_translation(spanish_text):
    """
    Function to return the Tzotzil translation for a given Spanish text.
    """
    spanish_text = spanish_text.lower()  # Ensure the input is lowercase
    tzotzil_translation = spanish_to_tzotzil.get(spanish_text, "Translation not available")
    return tzotzil_translation

# Translation route for POST requests
@app.route('/translate', methods=['POST'])
def translate():
    global last_spanish_text, last_tzotzil_translation  # Use global variables to store text

    # Extract Spanish text from the JSON request
    data = request.get_json()
    spanish_text = data.get("text", "").lower()

    # Get the Tzotzil translation
    tzotzil_translation = get_translation(spanish_text)

    # Store the last text and translation
    last_spanish_text = spanish_text
    last_tzotzil_translation = tzotzil_translation

    # Return only the Tzotzil translation in the response
    response = jsonify({"tzotzil_text": tzotzil_translation})
    return response

# Route to expose the last translated text
@app.route('/last-translation', methods=['GET'])
def last_translation():
    """
    Return the last translated Spanish text and the corresponding Tzotzil translation.
    """
    if last_spanish_text and last_tzotzil_translation:
        return jsonify({
            "spanish_text": last_spanish_text,
            "tzotzil_text": last_tzotzil_translation
        })
    else:
        return jsonify({"error": "No translation available yet"}), 404

if __name__ == '__main__':
    app.run(debug=True)
