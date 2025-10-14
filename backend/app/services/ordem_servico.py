from app import db
from app.models.models import OrdemServico, Pecas_Ordem_Servico, Estoque
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
        db.session.flush()

        pecas = data.get("pecas_utilizadas", [])
        for p in pecas:
            peca_id = p.get("peca_id")
            estoque = Estoque.query.filter_by(peca_id=peca_id).first()
            peca_nome = estoque.peca.nome if estoque and estoque.peca else f"ID {peca_id}"
            try:
                quantidade = int(p.get("quantidade"))
            except (TypeError, ValueError):
                raise Exception(f"Quantidade inválida para a peça {peca_nome}")
            
            if peca_id is None or quantidade is None:
                raise Exception("Dados de peças incompletos")
            if not isinstance(quantidade, int) or quantidade <= 0:
                raise Exception("Quantidade invalida para a peça selecionada!")

            estoque = Estoque.query.filter_by(peca_id=peca_id).first()
            if not estoque:
                raise Exception(f"Estoque da peça {peca_nome} não encontrado!")
            if estoque.qtd < quantidade:
                raise Exception(f"Estoque insuficiente para a peça {peca_nome}!")
            
            estoque.qtd -= quantidade

            uso_os = Pecas_Ordem_Servico(
                os_id = ordem.id,
                peca_id = peca_id,
                quantidade = quantidade
            )
            db.session.add(uso_os)
        
        db.session.commit()
        print(f"****************Peça debitada: {peca_id} e {quantidade}***************")
        return None, ordem
    
    except Exception as e:
        db.session.rollback()
        print("*********erro ao criar ordem:*********** ", e)
        return str(e), None


def atualizar_ordem(id, data):
    ordem = OrdemServico.query.get(id)
    if not ordem:
        return "Ordem não encontrada", None
    pecas = data.get("pecas_utilizadas", [])
    for p in pecas:
        peca_id = p.get("peca_id")
        estoque = Estoque.query.filter_by(peca_id=peca_id).first()
        peca_nome = estoque.peca.nome if estoque and estoque.peca else f"ID {peca_id}"
        try:
            quantidade = int(p.get("quantidade"))
        except (TypeError, ValueError):
            return f"Quantidade inválida para a peça {peca_nome}", None

        if peca_id is None or quantidade is None:
            return "Dados de peças incompletos", None
        if not isinstance(quantidade, int) or quantidade <= 0:
            return "Quantidade invalida para a peça selecionada!", None

        if not estoque:
            return f"Estoque da peça {peca_nome} não encontrado!", None
        if estoque.qtd < quantidade:
            return f"Estoque insuficiente para a peça {peca_nome}!", None
        
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
        pecas_usadas = Pecas_Ordem_Servico.query.filter_by(os_id=id).all()
        for pu in pecas_usadas:
            estoque = Estoque.query.filter_by(peca_id = pu.peca_id).first()
            if estoque:
                estoque.qtd += pu.quantidade
                print(f"*********Peça devolvida ao estoque!**********")

        for pu in pecas_usadas:
            db.session.delete(pu)
            
        db.session.delete(ordem)
        db.session.commit()

        return None, ordem
    
    except Exception as e:
        db.session.rollback()
        print("**********Erro ao excluir ordem!***********")
        return str(e), None
