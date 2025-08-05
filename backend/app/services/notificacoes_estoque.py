from app.models.models import Estoque
from app.utils.json_response import json_unicode

def listar_notificacoes():
    try:
        pecas_alerta = Estoque.query.filter(Estoque.qtd <= Estoque.qtd_min).all()
        alertas = [{
            "id": p.id,
            "mensagem": f"Peça '{p.peca.nome}' abaixo do mínimo ({p.qtd} un. restantes)"
        } for p in pecas_alerta]
        return json_unicode(alertas, 200)
    except Exception as e:
        return json_unicode({"erro": str(e)}, 500)