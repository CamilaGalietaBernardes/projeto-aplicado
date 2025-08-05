from flask import Blueprint, request, jsonify
from app.utils.json_response import json_unicode
from app.services.peca import listar_pecas, nova_peca, atualizar_peca, excluir_peca
from app.services.ordem_servico import listar_ordens, nova_ordem, atualizar_ordem, excluir_ordem
from app.services.usuario import atualiza_usuario, deleta_usuario, cria_usuario, listar_usuarios
from app.services.login import autenticar_usuario
from app.services.alertas import listar_alertas_reposicao
from app.services.notificacoes_estoque import listar_notificacoes

bp = Blueprint("main", __name__)


@bp.route("/")
def home():
    return json_unicode({"message": "Aplicação Flask com PostgreSQL funcionando!"})

# =================== LOGIN ====================


@bp.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    erro, usuario = autenticar_usuario(data)

    if erro:
        return json_unicode({"erro": erro}, 401)

    return jsonify(usuario.to_dict()), 200

# =================== USUÁRIOS ====================


@bp.route("/usuarios", methods=["GET"])
def listar_usuarios_route():
    erro, usuarios = listar_usuarios()
    if erro:
        return json_unicode({"erro": erro}, 500)
    return json_unicode([u.to_dict() for u in usuarios], 200)


@bp.route("/usuarios", methods=["POST"])
def criar_usuario():
    data = request.get_json()
    campos = ["nome", "email", "funcao", "setor", "senha"]
    for campo in campos:
        if campo not in data:
            return json_unicode({"erro": f"Campo obrigatório {campo} ausente!"}, 400)

    erro, usuario = cria_usuario(data)

    if erro:
        status = 400 if erro == "Email já cadastrado." else 500
        return json_unicode({"erro": erro}, status)

    return json_unicode(usuario.to_dict(), 201)


@bp.route("/usuarios/<int:id>", methods=["PUT"])
def atualizar_usuario(id):
    data = request.get_json()
    erro = atualiza_usuario(id, data)

    if erro:
        status = 404 if erro == "Usuário não encontrado" else 500
        return json_unicode({"erro": erro}, status)

    return json_unicode({"mensagem": "Usuário atualizado com sucesso!"}, 200)


@bp.route("/usuarios/<int:id>", methods=["DELETE"])
def excluir_usuario(id):
    erro = deleta_usuario(id)

    if erro:
        status = 404 if erro == "Usuário não encontrado" else 500
        return json_unicode({"erro": erro}, status)

    return json_unicode({"mensagem": "Usuário excluído com sucesso!"}, 200)

# =================== PEÇAS / ESTOQUE ====================


@bp.route("/peca", methods=["GET"])
def listar_pecas_route():
    erro, estoques = listar_pecas()
    if erro:
        return json_unicode({"erro": erro}, 500)
    return json_unicode([e.to_dict() for e in estoques], 200)


@bp.route("/peca", methods=["POST"])
def nova_peca_route():
    data = request.get_json()
    erro, estoque = nova_peca(data)
    if erro:
        status = 400 if erro in (
            "Dados incompletos", "Peça já cadastrada") else 500
        return json_unicode({"erro": erro}, status)
    return json_unicode(estoque.to_dict(), 201)


@bp.route("/peca/<int:id>", methods=["PUT"])
def atualizar_peca_route(id):
    data = request.get_json()
    erro = atualizar_peca(id, data)
    if erro:
        status = 404 if erro == "Peça/Estoque não encontrado" else 500
        return json_unicode({"erro": erro}, status)
    return json_unicode({"mensagem": "Atualizado com sucesso"}, 200)


@bp.route("/peca/<int:id>", methods=["DELETE"])
def excluir_peca_route(id):
    erro = excluir_peca(id)
    if erro:
        status = 404 if erro == "Peça não encontrada" else 500
        return json_unicode({"erro": erro}, status)
    return json_unicode({"mensagem": "Peça excluída com sucesso!"}, 200)

# =================== ORDENS DE SERVIÇO ====================


@bp.route("/ordemservico", methods=["GET"])
def listar_ordens_route():
    erro, ordens = listar_ordens()
    if erro:
        return json_unicode({"erro": erro}, 500)
    return json_unicode([o.to_dict() for o in ordens], 200)


@bp.route("/ordemservico", methods=["POST"])
def nova_ordem_route():
    data = request.get_json()
    erro, ordem = nova_ordem(data)
    if erro:
        status = 400 if erro.startswith("Campo") else 500
        return json_unicode({"erro": erro}, status)
    return json_unicode(ordem.to_dict(), 201)


@bp.route("/ordemservico/<int:id>", methods=["PUT"])
def atualizar_ordem_route(id):
    data = request.get_json()
    erro, ordem = atualizar_ordem(id, data)
    if erro:
        status = 404 if erro == "Ordem não encontrada" else 500
        return json_unicode({"erro": erro}, status)
    return json_unicode({"mensagem": "Atualizado com sucesso"}, 200)


@bp.route("/ordemservico/<int:id>", methods=["DELETE"])
def excluir_ordem_route(id):
    erro, _ = excluir_ordem(id)
    if erro:
        status = 404 if erro == "Ordem não encontrada" else 500
        return json_unicode({"erro": erro}, status)
    return json_unicode({"mensagem": "Ordem excluída com sucesso"}, 200)

# =================== ALERTAS ====================

@bp.route("/estoque/alertas", methods = ["GET"])
def alertas_estoque():
    erro, dados = listar_alertas_reposicao()
    if erro:
        return jsonify({"erro": erro}), 500
    return jsonify([e.to_dict() for e in dados]), 200

@bp.route("/notificacoes-estoque", methods = ["GET"])
def get_notificacoes():
    return listar_notificacoes()


