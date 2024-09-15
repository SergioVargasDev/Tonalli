from flask import Flask, render_template, request, jsonify
from decouple import config
from config import config

from routes import Usuarios


app=Flask(__name__)

def page_not_found(error):
    return "<h1>Not Found page</h1>", 404


        
if __name__ == '__main__':
    app.config.from_object(config['development'])
    
    # BluePrints
    app.register_blueprint(Usuarios.main,url_prefix='/api/usuarios')
    
    #Errores
    app.register_error_handler(404, page_not_found)
    app.run()