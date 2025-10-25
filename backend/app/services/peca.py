from app import db
from app.models.models import Estoque, Peca, db
from sqlalchemy.orm import joinedload

def listar_pecas():
    try:
        estoques = db.session.query(Estoque).options(joinedload(Estoque.peca)).all()
        return None, estoques
    except Exception as e:
        return str(e), None


def nova_peca(data):
    if not all(k in data for k in ("nome", "categoria", "qtd", "qtd_min")):
        return "Dados incompletos", None

    if Peca.query.filter_by(nome=data["nome"], categoria=data["categoria"]).first():
        return "Peça já cadastrada", None
    
    try:
        qtd = int(data["qtd"])
        qtd_min = int(data["qtd_min"])
        if qtd < 0 or qtd_min < 0:
            return "Quantidade e quantidade mínima devem ser valores inteiros positivos", None
    except (ValueError, TypeError):
        return "Quantidade e quantidade mínima devem ser números inteiros", None

    try:
        nova = Peca(nome=data["nome"], categoria=data["categoria"])
        db.session.add(nova)
        db.session.commit()

        estoque = Estoque(qtd=data["qtd"], qtd_min=data["qtd_min"], peca_id=nova.id)
        db.session.add(estoque)
        db.session.commit()

        return None, estoque
    except Exception as e:
        db.session.rollback()
        return str(e), None


def atualizar_peca(id, data):
    estoque = Estoque.query.options(joinedload(Estoque.peca)).get(id)
    if not estoque:
        return "Peça/Estoque não encontrado", None
    
    try:
        if "qtd" in data:
            qtd = int(data["qtd"])
            if qtd < 0:
                return "Quantidade deve ser um número inteiro positivo", None
            estoque.qtd = qtd

        if "qtd_min" in data:
            qtd_min = int(data["qtd_min"])
            if qtd_min < 0:
                return "Quantidade mínima deve ser um número inteiro positivo", None
            estoque.qtd_min = qtd_min
    except (ValueError, TypeError):
        return "Quantidade e quantidade mínima devem ser números inteiros", None


    estoque.peca.nome = data.get("nome", estoque.peca.nome)
    estoque.peca.categoria = data.get("categoria", estoque.peca.categoria)
    estoque.qtd = data.get("qtd", estoque.qtd)
    estoque.qtd_min = data.get("qtd_min", estoque.qtd_min)

    try:
        db.session.commit()
        return None
    except Exception as e:
        db.session.rollback()
        return str(e)


def excluir_peca(id):
    peca = Peca.query.get(id)
    if not peca:
        return "Peça não encontrada", None

    try:
        db.session.delete(peca)
        db.session.commit()
        return None
    except Exception as e:
        db.session.rollback()
        msg = "Existem Ordem de serviço para esta peça, não é possível excluir" \
            if "violates foreign key constraint" in str(e) else str(e)
        return msg
