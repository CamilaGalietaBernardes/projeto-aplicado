from app import db
from app.models.models import OrdemServico
from sqlalchemy.orm import joinedload


def listar_ordens():
    try:
        ordens = OrdemServico.query.options(
            joinedload(OrdemServico.equipamento),
            joinedload(OrdemServico.solicitante)
        ).all()
        return None, ordens
    except Exception as e:
        return str(e), None


def nova_ordem(data):
    campos = ['solicitante_id', 'tipo', 'setor', 'data',
              'recorrencia', 'detalhes', 'status', 'equipamento_id']
    for campo in campos:
        if campo not in data:
            return f"Campo {campo} ausente", None

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
        return None, ordem
    except Exception as e:
        db.session.rollback()
        return str(e), None


def atualizar_ordem(id, data):
    ordem = OrdemServico.query.get(id)
    if not ordem:
        return "Ordem não encontrada", None

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
        return None, ordem
    except Exception as e:
        db.session.rollback()
        return str(e), None


def excluir_ordem(id):
    ordem = OrdemServico.query.get(id)
    if not ordem:
        return "Ordem não encontrada", None

    try:
        db.session.delete(ordem)
        db.session.commit()
        return None, ordem
    except Exception as e:
        db.session.rollback()
        return str(e), None
