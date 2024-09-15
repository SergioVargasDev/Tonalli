from database.db import get_connection
from .entities.Usuario import Usuario
class UsuarioModel():
    
    @classmethod
    def get_usuarios(self):
        try:
            connection = get_connection()
            usuarios = []
            
            with connection.cursor() as cursor:
                cursor.execute("SELECT cuentaId, correo, usuario,contrasena FROM Cuenta")
                resultset = cursor.fetchall()
                
                for row in resultset:
                    usuario = Usuario(row[0],row[1],row[2],row[3])
                    usuarios.append(usuario.to_JSON())
            connection.close()
            return usuarios
        except Exception as ex:
            raise Exception(ex)
        
    @classmethod
    def login(self, usuario):
        try:
            connection = get_connection()
            
            with connection.cursor() as cursor:
                cursor.execute('CALL Login(%s, %s, %s)', (usuario.usuario, usuario.contrasena, None))                
                #obtener el resultado
                result = cursor.fetchone()
            connection.close()
            return result[0]
        except Exception as ex:
            raise Exception(ex)
    @classmethod
    def register(self,usuario,perfil):
        try:
            connection = get_connection()
            
            with connection.cursor() as cursor:
            # Corregir la forma de acceder a los atributos
                cursor.execute('SELECT Register(%s, %s, %s, %s, %s)', 
                           (usuario.usuario, usuario.contrasena, usuario.correo, perfil.nombre, perfil.apellido))
                result = cursor.fetchone()
            
            connection.commit()
            connection.close()
            if result:
                return result[0]
            else:
                return None  # Si no hay resultados, retornar None o un valor adecuado
        
        
        except Exception as ex:
            raise Exception(ex)