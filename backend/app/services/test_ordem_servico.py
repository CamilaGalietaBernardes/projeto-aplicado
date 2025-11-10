import pytest
from unittest.mock import patch, MagicMock
from datetime import datetime, timedelta
from app.services import ordem_servico


# =================== listar_ordens ===================

@patch("app.services.ordem_servico.joinedload")
@patch("app.services.ordem_servico.OrdemServico")
def test_listar_ordens_sucesso(mock_model, mock_joinedload):
    mock_joinedload.return_value = None
    mock_ordem = MagicMock()
    mock_ordem.status = "pendente"
    mock_ordem.data = datetime.now()
    mock_model.query.options.return_value.all.return_value = [mock_ordem]

    erro, ordens = ordem_servico.listar_ordens()

    assert erro is None
    assert len(ordens) == 1
    assert ordens[0].status in ["Em Andamento", "Atrasada"]


@patch("app.services.ordem_servico.joinedload")
@patch("app.services.ordem_servico.OrdemServico")
def test_listar_ordens_erro(mock_model, mock_joinedload):
    mock_joinedload.return_value = None
    mock_model.query.options.side_effect = Exception("DB error")
    erro, ordens = ordem_servico.listar_ordens()
    assert "DB error" in erro
    assert ordens is None


# =================== nova_ordem ===================

@patch("app.services.ordem_servico.db")
@patch("app.services.ordem_servico.Estoque")
@patch("app.services.ordem_servico.OrdemServico")
@patch("app.services.ordem_servico.Pecas_Ordem_Servico")
def test_nova_ordem_sucesso(mock_pos, mock_ordem, mock_estoque, mock_db):
    estoque_obj = MagicMock()
    estoque_obj.qtd = 10
    estoque_obj.peca.nome = "Parafuso"
    mock_estoque.query.filter_by.return_value.first.return_value = estoque_obj

    mock_ordem_instance = MagicMock()
    mock_ordem_instance.id = 1
    mock_ordem.return_value = mock_ordem_instance

    data = {
        "solicitante_id": 1,
        "tipo": "Corretiva",
        "setor": "Elétrica",
        "data": datetime.now(),
        "recorrencia": "Única",
        "detalhes": "Troca de fusível",
        "status": "Pendente",
        "equipamento_id": 1,
        "pecas_utilizadas": [{"peca_id": 1, "quantidade": 2}]
    }

    erro, ordem = ordem_servico.nova_ordem(data)

    assert erro is None
    mock_db.session.add.assert_called()
    mock_db.session.commit.assert_called()
    assert ordem == mock_ordem_instance


def test_nova_ordem_campo_ausente():
    data = {"tipo": "Preventiva"}
    erro, ordem = ordem_servico.nova_ordem(data)
    assert "ausente" in erro
    assert ordem is None


@patch("app.services.ordem_servico.OrdemServico")
def test_atualizar_ordem_nao_encontrada(mock_ordem):
    mock_ordem.query.get.return_value = None
    erro, ordem = ordem_servico.atualizar_ordem(99, {})
    assert erro == "Ordem não encontrada"
    assert ordem is None


@patch("app.services.ordem_servico.db")
@patch("app.services.ordem_servico.Estoque")
@patch("app.services.ordem_servico.Pecas_Ordem_Servico")
@patch("app.services.ordem_servico.OrdemServico")
def test_excluir_ordem_sucesso(mock_ordem, mock_pos, mock_estoque, mock_db):
    mock_ordem_inst = MagicMock()
    mock_ordem.query.get.return_value = mock_ordem_inst

    mock_pos.query.filter_by.return_value.all.return_value = [
        MagicMock(peca_id=1, quantidade=3)
    ]

    estoque_obj = MagicMock()
    estoque_obj.qtd = 5
    mock_estoque.query.filter_by.return_value.first.return_value = estoque_obj

    erro, ordem = ordem_servico.excluir_ordem(1)
    assert erro is None
    assert ordem == mock_ordem_inst
    mock_db.session.commit.assert_called_once()


@patch("app.services.ordem_servico.OrdemServico")
def test_excluir_ordem_nao_encontrada(mock_ordem):
    mock_ordem.query.get.return_value = None
    erro, ordem = ordem_servico.excluir_ordem(999)
    assert erro == "Ordem não encontrada"
    assert ordem is None


@patch("app.services.ordem_servico.db")
@patch("app.services.ordem_servico.Estoque")
@patch("app.services.ordem_servico.Pecas_Ordem_Servico")
@patch("app.services.ordem_servico.OrdemServico")
def test_excluir_ordem_excecao(mock_ordem, mock_pos, mock_estoque, mock_db):
    mock_ordem_inst = MagicMock()
    mock_ordem.query.get.return_value = mock_ordem_inst

    mock_db.session.commit.side_effect = Exception("erro no commit")

    erro, _ = ordem_servico.excluir_ordem(1)

    assert "erro" in erro.lower()
    mock_db.session.rollback.assert_called_once()
