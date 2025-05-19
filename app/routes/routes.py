from flask import Flask, Blueprint, request
from app.utils.json_response import json_unicode
from app.models.models import Estoque, Usuario, OrdemServico, db

bp = Blueprint("main", __name__)

@bp.route("/")
def home():
    return json_unicode({"message" : "Aplicação Flask com ProsgreSQL funcionando!"})

@bp.route("/usuarios", methods=["GET"])
def listar_usuarios():
    usuarios = Usuario.query.all()
    resultado = [usuario.to_dict() for usuario in usuarios]
    return json_unicode(resultado, 200)

@bp.route('/usuarios', methods = ['POST'])
def criar_usuario():
    data = request.get_json()

    campos_obrigatorios = ["nome", "email", "funcao", "setor", "senha"]
    for campo in campos_obrigatorios:
        if campo not in data:
            return json_unicode({"erro": f"Campo obrigatório {campo} ausente!"}, 400)
        
        if Usuario.query.filter_by(email=data["email"]).first():
            return json_unicode({"erro": f"Email já cadastrado."}, 400)

        novo_usuario = Usuario(
            nome=data["nome"],
            email=data["email"],
            funcao=data["funcao"],
            setor=data["setor"],
        )
        novo_usuario.set_senha(data["senha"])

        try:
            db.session.add(novo_usuario)
            db.session.commit()
            return json_unicode(novo_usuario.to_dict(), 200)
        except Exception as e:
            db.session.rollback()
            return json_unicode({"erro" : str(e)}, 500)
        
@bp.route('/estoque', methods = ['POST'])
def cadastrar_peca():
    data = request.get_json()

    campos_obrigatorios = ['peca', 'qtd', 'categoria']

    for campo in campos_obrigatorios:
        if campo not in data:
            return json_unicode({'erro': f'Campo obrigatório {campo} ausente'}, 400)
        
    nova_peca = Estoque(
        peca = data['peca'],
        qtd = data['qtd'],
        categoria = data['categoria']
    )

    try:
        db.session.add(nova_peca)
        db.session.commit()
        return json_unicode({'mensagem': f'Peça cadastrada com sucesso!'}, 201)
    except Exception as e:
        db.session.rollback()
        return json_unicode({'erro': str(e)}, 500)

@bp.route('/estoque', methods = ['GET'])
def listar_estoque():
    peca = request.args.get('peca')
    qtd = request.args.get('qtd')
    categoria = request.args.get('categoria')

    query = Estoque.query

    if peca:
        query = query.filter(Estoque.peca.ilike(f'%{peca}%'))

    if qtd:
        query = query.filter(Estoque.qtd.ilike(f'%{qtd}%'))

    if categoria:
        query = query.filter(Estoque.categoria.ilike(f'%{categoria}%'))
        
    pecas = query.all()

    resultado = [{
        'id': p.id,
        'peca': p.peca,
        'qtd': p.qtd,
        'categoria': p.categoria
    } for p in pecas]

    return json_unicode(resultado, 200)

@bp.route('/estoque/<int:id>', methods = ['PUT'])
def atualizar_peca(id):
    peca = Estoque.query.get(id)

    if not peca:
        return json_unicode({"erro": "Peça não encontrada!"}, 404)
    
    data = request.get_json()

    if "peca" in data:
        peca.peca = data["peca"]

    if "qtd" in data:
        peca.qtd = data['qtd']

    if "categoria" in data:
        peca.categoria = data['categoria']


    try:
        db.session.commit()
        return json_unicode({"mensagem": "Peça atualizada com sucesso!"}, 200)
    except Exception as e:
        db.session.rollback()
        return json_unicode({"erro": str(e)}, 500)

@bp.route('/estoque/<int:id>', methods = ['DELETE'])
def excluir_peca(id):
    peca = Estoque.query.get(id)
    if not peca:
        return json_unicode({"Erro": "Peça não encontrada!"}, 404)
    
    try: 
        db.session.delete(peca)
        db.session.commit()
        return json_unicode({"mensagem": "Peça excluída com sucesso!"}, 200)
    
    except Exception as e:
        db.session.rollback()
        return json_unicode({"Erro": str(e)}, 500)
    
@bp.route('/estoque/entrada', methods=['POST'])
def entrada_peca():
    data = request.get_json()
    peca_id = data.get('peca_id')
    quantidade = data.get('quantidade')

    if not peca_id or not quantidade:
        return json_unicode({"erro": "É necessário informar o ID da peça e a quantidade."}, 400)
    
    peca = Estoque.query.get(peca_id)
    if not peca:
        return json_unicode({"Erro": "Peça não encontrada!"}, 404)
    
    try:
        peca.qtd += quantidade
        db.session.commit()
        return json_unicode({"mensagem": "Entrada registrada com sucesso!", "peca": {
            "id": peca.id,
            "peca": peca.peca,
            "qtd": peca.qtd,
            "categoria": peca.categoria
        }}, 200)
    except Exception as e:
        db.session.rollback()
        return json_unicode({"Erro": str(e)}, 500)
    

@bp.route('/estoque/saida', methods = ['POST'])
def saida_peca():
    data = request.get_json()
    peca_id = data.get('peca_id')
    quantidade = data.get("quantidade")

    if not peca_id or not quantidade:
        return json_unicode({"erro": "É necessário informar o ID da peça e a quantidade"}, 400)
    
    peca = Estoque.query.get(peca_id)
    if not peca:
        return json_unicode({'erro': f"Peça não encontrada!"}, 404)
    
    if peca.qtd < quantidade:
        return json_unicode({'erro': f'Estoque insuficiente. Quantidade atual: {peca.qtd}'}, 400)
    
    try:
        peca.qtd -= quantidade
        db.session.commit()
        return json_unicode({
            "mensagem": "Saída registrada com sucesso!",
            "peca": {
                "id": peca.id,
                "peca": peca.peca,
                "qtd": peca.qtd,
                "categoria": peca.categoria
            }
        }, 200)
    except Exception as e:
        db.session.rollback()
        return json_unicode({"erro": str(e)}, 500)
    

