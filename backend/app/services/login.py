from app.models.models import Usuario

def autenticar_usuario(data):
    email = data.get("usuario")
    senha = data.get("senha")

    if not email or not senha:
        return "Usuário ou senha não fornecidos", None

    usuario = Usuario.query.filter_by(email=email).first()
    if usuario and usuario.verificar_senha(senha):
        return None, usuario

    return "Usuário ou senha inválidos", None
