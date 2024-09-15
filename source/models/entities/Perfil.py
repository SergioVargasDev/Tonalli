class Perfil():
    def __init__(self, perfilId, apellido, cuentaId, nombre) -> None:
        self.perfilId = perfilId
        self.apellido = apellido
        self.cuentaId = cuentaId
        self.nombre = nombre
        
    def to_JSON(self):
        return {
            'perfilId': self.perfilId,
            'apellido': self.apellido,
            'cuentaId': self.cuentaId,
            'nombre': self.nombre
        }