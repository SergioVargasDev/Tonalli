from flask import Blueprint, jsonify, request

#models
from models.UsuarioModel import UsuarioModel
from models.entities.Usuario import Usuario
from models.entities.Perfil import Perfil

main=Blueprint('movie_blueprint',__name__)

@main.route('/')
def get_usuarios():
    try:
        movies = UsuarioModel.get_usuarios()
        return jsonify(movies)
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500
    
@main.route('/login',methods=['POST'])
def login_usuario():
    try:
        # Obtener los datos desde el cuerpo de la solicitud
        data = request.get_json()
        
        usuario = data.get('usuario')
        contrasena = data.get('contrasena')
        
        if not usuario or not contrasena:
            return jsonify({'message': 'Faltan datos para el login'}), 400
        
         # Crear una instancia de Usuario con los datos proporcionados
        user_instance = Usuario(None, None, usuario, contrasena)  # No se necesita cuentaId ni correo para el login

        # Intentar login a través del modelo
        es_valido = UsuarioModel.login(user_instance)
        
        if es_valido:
            return jsonify({'message': 'Login exitoso'})
        else:
            return jsonify({'message': 'Credenciales incorrectas'}), 401
        
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500
    
@main.route('/register', methods=['POST'])
def register_usuario():
    try:
        # Obtener los datos desde el cuerpo de la solicitud
        data = request.get_json()

        usuario = data.get('usuario')
        contrasena = data.get('contrasena')
        correo = data.get('correo')
        nombre = data.get('nombre')
        apellido = data.get('apellido')

        # Validar que todos los campos estén presentes
        if not usuario or not contrasena or not correo or not nombre or not apellido:
            return jsonify({'message': 'Faltan datos para el registro'}), 400

        # Crear una instancia de Usuario y Perfil con los datos proporcionados
        user_instance = Usuario(None, correo, usuario, contrasena)
        perfil_instance = Perfil(None, apellido, None, nombre)
        # Intentar el registro a través del modelo
        UsuarioModel.register(user_instance, perfil_instance)

        return jsonify({'message': 'Registro exitoso'}), 201
        
    except Exception as ex:
        return jsonify({'message': str(ex)}), 500