from app.models.models import Estoque

def listar_alertas_reposicao():
    try:
        alertas = Estoque.query.filter(Estoque.qtd < Estoque.qtd_min).all()
        return None, alertas
    
    except Exception as e:
        return str(e), None