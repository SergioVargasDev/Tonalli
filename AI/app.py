from flask import Flask, request, jsonify

app = Flask(__name__)

# Hardcoded Spanish to Tzotzil dictionary
spanish_to_tzotzil = {
    "hola": "k´ux",
    "como te llamas": "k'usi mi a?at",
    "trabajo": "abtel",
    "adios": "bix a",
    "donde esta el baño": "banti ta ik’el",
    "cuanto cuesta esto": "banti p’ak'otik jich",
    "como llego a la plaza principal": "banti li'il ta sk'inal pat",
    "hay algun restaurante cerca": "yalal cha’b kotanik ta tulan chulnal",
    "donde puedo comprar comida": "banti ta sp'at nax vinajel",
    "como puedo llegar al mercado": "banti avil ta sjul ta vinik ba sk'inal",
    "tienes agua": "a’utz ya",
    "que me recomiendas visitar": "jabil ava me’bel ta jich sk'inal",
    "como se dice esto en tzotzil": "banti x-avu’un ta tzotzil",
    "donde esta el medico mas cercano": "banti ya’at sjul xelol ta vinik ba",
    "puedes ayudarme": "ach’a’am spa",
    "a que hora abre el mercado": "banti ta yotik k’ux avil ta sk’inal pat",
    "quiero probar comida tradicional": "vok’ va k’axojel vinajel ta ton ta yich lo’on",
    "como se llama este lugar": "banti ta x-ix ta k’usi mi sk’inal ta vinik ba",
    "hay guias turisticos aqui": "ya xich’avel",
    "donde puedo hospedarme": "banti jchabil va avo vinik ta yach’ol kotanik",
    "que festividades hay durante esta temporada": "jabil va a chalal yu’un lo’on",
    "cuanto cuesta el transporte": "banti s-b’o'otik stonil ta bus",
    "me gustaria aprender algunas palabras en tzotzil": "vok’ va skan k’op ti jchi’k ta tzotzil",
    "es seguro caminar por aqui en la noche": "ta votik li'il ta pok ta yich naxel ba jich",
    "cuanto tiempo tarda en llegar a la cascada": "banti xa va ajil avil ta sk'inal vo’el ba",
    "donde puedo encontrar artesanias locales": "banti ta xak kotanik ta p’ijotik ba ajk’opotik",
    "cual es el plato tipico de aqui": "jabil snixtaotik ba ja’uk ta yich yich vinik ba",
    "donde queda la estacion de autobuses": "banti kotavil ta sk’inal nax k'inal ba",
    "como se llega al pueblo mas cercano": "banti avil ta jomel ba a kot ch'ivitik",
    "hay cajeros automaticos cerca": "yalal ch’a vinik ba snak naxel ba ju’un banko ta vinik ba",
    "cual es la mejor epoca para visitar": "jabil xa'abal snop ba a yich ajavel",
    "a que hora sale el autobus": "banti va avo avil ta bus li'il ba",
    "donde puedo cambiar dinero": "banti ta sjab kotanik ta vinik ba",
    "donde puedo comprar ropa tradicional": "banti ta xkotanik ta cha’b ba at sat vinik ba ta xk’elelotik",
    "hay caminatas guiadas por las montanas": "yalal xa’aletik ba a chalal ta vo’otik jich ba k'anal",
    "hay algun festival este fin de semana": "yalal x-ich va a k’opotik ta yich xelol a xchalal ba k'inal ba",
    "puedo tomar fotografias aqui": "avok’ va snopotik ta jek’otik ba a sjun ba k’uxotik",
    "es necesario algun permiso para visitar las cuevas": "xa jabil va avo avil cha’b xa’aletik ta lumatik",
    "que plantas medicinales usan aqui": "jabil xi ba vinik ajvinikotik ta ch’ul ajk’elotik ta vinik ba",
    "donde puedo tomar un tour en barco": "banti ta xkotanik ta vinik ba a ajxa’aletik ba ta vinik ba ta sjulotik",
    "hay alguna fiesta esta noche": "ya vinik ba yich a chalal cha’aletik ta jch’el ba va ta pok ta yich ba",
    
    # Nuevas frases personales para iniciar plática:
    "como estas": "k’ux a’",
    "de donde eres": "banti mi a ixim",
    "cuantos años tienes": "banti xa ap k’in",
    "vives aqui": "ta yilot a lum?",
    "que haces": "banti a xak’baj",
    "tienes familia": "ya a lok’el",
    "cuantos hijos tienes": "banti x-ap ya a jtatik",
    "estas casado": "ta k’op a’ta sk’in",
    "te gusta vivir aqui": "xa avu’un xa’b va avo yil ta lum",
    "tienes animales": "ya a ya’b a k’op ta ch’ul ajbal?",
    "a que te dedicas": "banti xa yutik ch’ul ya’k’otel?",
    "te gusta hablar con los turistas": "xa avo yik’ va ak’opotik ta lumajel?"
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