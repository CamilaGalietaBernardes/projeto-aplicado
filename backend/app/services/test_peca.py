from unittest.mock import patch
import pytest
from unittest.mock import patch, MagicMock
from app.services import peca


# =================== listar_pecas ===================

@patch("app.services.peca.db")
@patch("app.services.peca.joinedload")
def test_listar_pecas_sucesso(mock_joined, mock_db):
    estoque_mock = MagicMock()
    mock_db.session.query.return_value.options.return_value.all.return_value = [
        estoque_mock]

    erro, estoques = peca.listar_pecas()
    assert erro is None
    assert len(estoques) == 1
    mock_db.session.query.assert_called_once()


@patch("app.services.peca.db")
@patch("app.services.peca.joinedload")
def test_listar_pecas_erro(mock_joined, mock_db):
    mock_db.session.query.side_effect = Exception("DB error")
    erro, estoques = peca.listar_pecas()
    assert "DB error" in erro
    assert estoques is None


# =================== nova_peca ===================

@patch("app.services.peca.db")
@patch("app.services.peca.Peca")
@patch("app.services.peca.Estoque")
def test_nova_peca_sucesso(mock_estoque, mock_peca, mock_db):
    mock_peca.query.filter_by.return_value.first.return_value = None
    nova_peca = MagicMock(id=1)
    mock_peca.return_value = nova_peca

    data = {"nome": "Parafuso", "categoria": "Fixação", "qtd": 10, "qtd_min": 2}
    erro, estoque = peca.nova_peca(data)

    assert erro is None
    mock_db.session.add.assert_called()
    mock_db.session.commit.assert_called()
    assert estoque == mock_estoque.return_value


def test_nova_peca_dados_incompletos():
    data = {"nome": "Parafuso"}
    erro, estoque = peca.nova_peca(data)
    assert "incompletos" in erro
    assert estoque is None


@patch("app.services.peca.Peca")
def test_nova_peca_ja_cadastrada(mock_peca):
    mock_peca.query.filter_by.return_value.first.return_value = True
    data = {"nome": "Parafuso", "categoria": "Fixação", "qtd": 10, "qtd_min": 2}
    erro, estoque = peca.nova_peca(data)
    assert "já cadastrada" in erro
    assert estoque is None


@patch("app.services.peca.Peca")
@patch("app.services.peca.db")
def test_nova_peca_qtd_invalida_tipo(mock_db, mock_peca):
    mock_peca.query.filter_by.return_value.first.return_value = None

    data = {"nome": "X", "categoria": "Y", "qtd": "abc", "qtd_min": 1}
    erro, estoque = peca.nova_peca(data)

    assert "números inteiros" in erro
    assert estoque is None


@patch("app.services.peca.Peca")
@patch("app.services.peca.db")
def test_nova_peca_qtd_negativa(mock_db, mock_peca):
    mock_peca.query.filter_by.return_value.first.return_value = None

    data = {"nome": "X", "categoria": "Y", "qtd": -1, "qtd_min": 1}
    erro, estoque = peca.nova_peca(data)

    assert "valores inteiros positivos" in erro
    assert estoque is None


@patch("app.services.peca.db")
@patch("app.services.peca.Peca")
def test_nova_peca_excecao_commit(mock_peca, mock_db):
    mock_peca.query.filter_by.return_value.first.return_value = None
    mock_db.session.commit.side_effect = Exception("Falha commit")
    data = {"nome": "X", "categoria": "Y", "qtd": 1, "qtd_min": 1}
    erro, estoque = peca.nova_peca(data)
    assert "Falha commit" in erro
    mock_db.session.rollback.assert_called_once()


# =================== atualizar_peca ===================

@patch("app.services.peca.db")
@patch("app.services.peca.joinedload")
@patch("app.services.peca.Estoque")
def test_atualizar_peca_sucesso(mock_estoque, mock_joined, mock_db):
    peca_obj = MagicMock(nome="Velha", categoria="Antiga")
    estoque_mock = MagicMock(peca=peca_obj, qtd=5, qtd_min=1)
    mock_estoque.query.options.return_value.get.return_value = estoque_mock

    data = {"nome": "Nova", "categoria": "Nova Cat", "qtd": 8, "qtd_min": 2}
    erro = peca.atualizar_peca(1, data)
    assert erro is None
    mock_db.session.commit.assert_called_once()


@patch("app.services.peca.joinedload")
@patch("app.services.peca.Estoque")
def test_atualizar_peca_nao_encontrada(mock_estoque, mock_joined):
    mock_estoque.query.options.return_value.get.return_value = None
    erro, _ = peca.atualizar_peca(1, {})
    assert "não encontrado" in erro


@patch("app.services.peca.db")
@patch("app.services.peca.joinedload")
@patch("app.services.peca.Estoque")
def test_atualizar_peca_excecao_commit(mock_estoque, mock_joined, mock_db):
    estoque_mock = MagicMock(peca=MagicMock())
    mock_estoque.query.options.return_value.get.return_value = estoque_mock
    mock_db.session.commit.side_effect = Exception("Erro commit")

    erro = peca.atualizar_peca(1, {"qtd": 5, "qtd_min": 1})
    assert "Erro commit" in erro
    mock_db.session.rollback.assert_called_once()


# =================== excluir_peca ===================

@patch("app.services.peca.db")
@patch("app.services.peca.Peca")
def test_excluir_peca_sucesso(mock_peca, mock_db):
    mock_inst = MagicMock()
    mock_peca.query.get.return_value = mock_inst
    erro = peca.excluir_peca(1)
    assert erro is None
    mock_db.session.delete.assert_called_once_with(mock_inst)
    mock_db.session.commit.assert_called_once()


@patch("app.services.peca.Peca")
def test_excluir_peca_nao_encontrada(mock_peca):
    mock_peca.query.get.return_value = None
    erro, _ = peca.excluir_peca(999)
    assert "não encontrada" in erro


@patch("app.services.peca.db")
@patch("app.services.peca.Peca")
def test_excluir_peca_excecao(mock_peca, mock_db):
    mock_inst = MagicMock()
    mock_peca.query.get.return_value = mock_inst
    mock_db.session.commit.side_effect = Exception(
        "violates foreign key constraint")

    erro = peca.excluir_peca(1)
    assert "não é possível excluir" in erro
    mock_db.session.rollback.assert_called_once()
