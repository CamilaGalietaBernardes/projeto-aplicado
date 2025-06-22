from flask import Blueprint, request, jsonify
from app.utils.json_response import json_unicode
from sqlalchemy.exc import IntegrityError
import psycopg2
from app.models.models import Estoque, Usuario, OrdemServico, Peca, db
from sqlalchemy.orm import joinedload

bp = Blueprint("main", __name__)


@bp.route("/")
def home():
    return json_unicode({"message": "Aplicação Flask com PostgreSQL funcionando!"})

# =================== LOGIN ====================


@bp.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    usuario = Usuario.query.filter_by(email=data["usuario"]).first()
    if usuario and usuario.verificar_senha(data["senha"]):
        return jsonify(usuario.to_dict()), 200
    return json_unicode({"erro": "Usuário ou senha inválidos"}, 401)

# =================== USUÁRIOS ====================


@bp.route("/usuarios", methods=["GET"])
def listar_usuarios():
    usuarios = Usuario.query.all()
    return json_unicode([u.to_dict() for u in usuarios], 200)


@bp.route("/usuarios", methods=["POST"])
def criar_usuario():
    data = request.get_json()
    campos = ["nome", "email", "funcao", "setor", "senha"]
    for campo in campos:
        if campo not in data:
            return json_unicode({"erro": f"Campo obrigatório {campo} ausente!"}, 400)

    if Usuario.query.filter_by(email=data["email"]).first():
        return json_unicode({"erro": "Email já cadastrado."}, 400)

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
        return json_unicode(novo.to_dict(), 201)
    except Exception as e:
        db.session.rollback()
        return json_unicode({"erro": str(e)}, 500)


@bp.route("/usuarios/<int:id>", methods=["DELETE"])
def excluir_usuario(id):
    usuario = Usuario.query.get(id)
    if not usuario:
        return json_unicode({"erro": "Usuário não encontrado"}, 404)

    try:
        db.session.delete(usuario)
        db.session.commit()
        return json_unicode({"mensagem": "Usuário excluído com sucesso!"}, 200)
    except Exception as e:
        db.session.rollback()
        return json_unicode({"erro": str(e)}, 500)


@bp.route("/usuarios/<int:id>", methods=["PUT"])
def atualizar_usuario(id):
    usuario = Usuario.query.get(id)
    if not usuario:
        return json_unicode({"erro": "Usuário não encontrado"}, 404)

    data = request.get_json()
    usuario.nome = data.get("nome", usuario.nome)
    usuario.email = data.get("email", usuario.email)
    usuario.funcao = data.get("funcao", usuario.funcao)
    usuario.setor = data.get("setor", usuario.setor)
    if "senha" in data:
        usuario.set_senha(data["senha"])

    try:
        db.session.commit()
        return json_unicode({"mensagem": "Usuário atualizado com sucesso!"}, 200)
    except Exception as e:
        db.session.rollback()
        return json_unicode({"erro": str(e)}, 500)

# =================== PEÇAS / ESTOQUE ====================


@bp.route("/peca", methods=["GET"])
def listar_pecas():
    estoques = db.session.query(Estoque).options(
        joinedload(Estoque.peca)).all()
    return json_unicode([e.to_dict() for e in estoques], 200)


@bp.route("/peca", methods=["POST"])
def nova_peca():
    data = request.get_json()
    if not all(k in data for k in ("nome", "categoria", "qtd", "qtd_min")):
        return json_unicode({"erro": "Dados incompletos"}, 400)

    if Peca.query.filter_by(nome=data["nome"], categoria=data["categoria"]).first():
        return json_unicode({"erro": "Peça já cadastrada"}, 400)

    try:
        nova = Peca(nome=data["nome"], categoria=data["categoria"])
        db.session.add(nova)
        db.session.commit()

        estoque = Estoque(
            qtd=data["qtd"], qtd_min=data["qtd_min"], peca_id=nova.id)
        db.session.add(estoque)
        db.session.commit()

        return json_unicode(estoque.to_dict(), 201)
    except Exception as e:
        db.session.rollback()
        return json_unicode({"erro": str(e)}, 500)


@bp.route("/peca/<int:id>", methods=["PUT"])
def atualizar_peca(id):
    estoque = Estoque.query.options(joinedload(Estoque.peca)).get(id)
    if not estoque:
        return json_unicode({"erro": "Peça/Estoque não encontrado"}, 404)

    data = request.get_json()
    estoque.peca.nome = data.get("nome", estoque.peca.nome)
    estoque.peca.categoria = data.get("categoria", estoque.peca.categoria)
    estoque.qtd = data.get("qtd", estoque.qtd)
    estoque.qtd_min = data.get("qtd_min", estoque.qtd_min)

    try:
        db.session.commit()
        return json_unicode({"mensagem": "Atualizado com sucesso"}, 200)
    except Exception as e:
        db.session.rollback()
        return json_unicode({"erro": str(e)}, 500)


@bp.route("/peca/<int:id>", methods=["DELETE"])
def excluir_peca(id):
    peca = Peca.query.get(id)
    if not peca:
        return json_unicode({"erro": "Peça não encontrada"}, 404)

    try:
        db.session.delete(peca)
        db.session.commit()
        return json_unicode({"mensagem": "Peça excluída com sucesso!"}, 200)
    except IntegrityError as e:
        if isinstance(e.orig, psycopg2.errors.ForeignKeyViolation):
            db.session.rollback()
            return json_unicode({"erro": "Existem Ordem de serviço para esta peça, não é possível excluir"}, 500)
        else:
            raise

# =================== ORDENS DE SERVIÇO ====================


@bp.route("/ordemservico", methods=["GET"])
def listar_ordens():
    ordens = OrdemServico.query.options(
        joinedload(OrdemServico.equipamento),
        joinedload(OrdemServico.solicitante)
    ).all()
    print([o.to_dict() for o in ordens])
    return json_unicode([o.to_dict() for o in ordens], 200)


@bp.route("/ordemservico", methods=["POST"])
def nova_ordem():
    data = request.get_json()
    campos = ['solicitante_id', 'tipo', 'setor', 'data',
              'recorrencia', 'detalhes', 'status', 'equipamento_id']
    for campo in campos:
        if campo not in data:
            return json_unicode({"erro": f"Campo {campo} ausente"}, 400)

    try:
        ordem = OrdemServico(
            equipamento_id=data["equipamento_id"],
            solicitante_id=data["solicitante_id"],
            tipo=data["tipo"],
            setor=data["setor"],
            data=data["data"],
            recorrencia=data["recorrencia"],
            detalhes=data["detalhes"],
            status=data["status"]
        )
        db.session.add(ordem)
        db.session.commit()
        return json_unicode(ordem.to_dict(), 201)
    except Exception as e:
        db.session.rollback()
        return json_unicode({"erro": str(e)}, 500)


@bp.route("/ordemservico/<int:id>", methods=["PUT"])
def atualizar_ordem(id):
    ordem = OrdemServico.query.get(id)
    if not ordem:
        return json_unicode({"erro": "Ordem não encontrada"}, 404)

    data = request.get_json()
    ordem.equipamento_id = data.get(
        "equipamento", {}).get("id", ordem.equipamento_id)
    ordem.solicitante_id = data.get(
        "solicitante", {}).get("id", ordem.solicitante_id)
    ordem.tipo = data.get("tipo", ordem.tipo)
    ordem.setor = data.get("setor", ordem.setor)
    ordem.data = data.get("data", ordem.data)
    ordem.recorrencia = data.get("recorrencia", ordem.recorrencia)
    ordem.detalhes = data.get("detalhes", ordem.detalhes)
    ordem.status = data.get("status", ordem.status)

    try:
        db.session.commit()
        return json_unicode({"mensagem": "Atualizado com sucesso"}, 200)
    except Exception as e:
        db.session.rollback()
        return json_unicode({"erro": str(e)}, 500)


@bp.route("/ordemservico/<int:id>", methods=["DELETE"])
def excluir_ordem(id):
    ordem = OrdemServico.query.get(id)
    if not ordem:
        return json_unicode({"erro": "Ordem não encontrada"}, 404)

    try:
        db.session.delete(ordem)
        db.session.commit()
        return json_unicode({"mensagem": "Ordem excluída com sucesso"}, 200)
    except Exception as e:
        db.session.rollback()
        return json_unicode({"erro": str(e)}, 500)
