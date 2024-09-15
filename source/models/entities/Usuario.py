class Usuario():
    def __init__(self, cuentaId, correo, usuario, contrasena) -> None:
        self.cuentaId = cuentaId
        self.correo = correo
        self.usuario = usuario
        self.contrasena = contrasena
        
    def to_JSON(self):
        return {
            'cuentaId': self.cuentaId,
            'correo': self.correo,
            'usuario': self.usuario,
            'contrasena': self.contrasena
        }