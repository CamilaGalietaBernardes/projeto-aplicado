from app.models.models import Usuario, db


def listar_usuarios():
    try:
        usuarios = Usuario.query.all()
        return None, usuarios
    except Exception as e:
        return str(e), None


def cria_usuario(data):
    if Usuario.query.filter_by(email=data["email"]).first():
        return "Email já cadastrado.", None

    novo = Usuario(
        nome=data["nome"],
        email=data["email"],
        funcao=data["funcao"],
        setor=data["setor"]
    )
    novo.set_senha(data["senha"])

    try:
        db.session.add(novo)
        db.session.commit()
        return None, novo
    except Exception as e:
        db.session.rollback()
        return str(e), None


def atualiza_usuario(usuario_id, data):
    usuario = Usuario.query.get(usuario_id)
    if not usuario:
        return "Usuário não encontrado", None

    usuario.nome = data.get("nome", usuario.nome)
    usuario.email = data.get("email", usuario.email)
    usuario.funcao = data.get("funcao", usuario.funcao)
    usuario.setor = data.get("setor", usuario.setor)

    if "senha" in data:
        usuario.set_senha(data["senha"])

    try:
        db.session.commit()
        return None
    except Exception as e:
        db.session.rollback()
        return str(e)


def deleta_usuario(usuario_id):
    usuario = Usuario.query.get(usuario_id)
    if not usuario:
        return "Usuário não encontrado", None

    try:
        db.session.delete(usuario)
        db.session.commit()
        return None
    except Exception as e:
        db.session.rollback()
        return str(e)
