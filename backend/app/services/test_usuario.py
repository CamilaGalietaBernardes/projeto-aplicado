import pytest
from unittest.mock import patch, MagicMock
from app.services import usuario


# =================== listar_usuarios ===================

@patch("app.services.usuario.Usuario")
def test_listar_usuarios_sucesso(mock_usuario):
    mock_user = MagicMock()
    mock_usuario.query.all.return_value = [mock_user]

    erro, usuarios = usuario.listar_usuarios()
    assert erro is None
    assert len(usuarios) == 1
    mock_usuario.query.all.assert_called_once()


@patch("app.services.usuario.Usuario")
def test_listar_usuarios_erro(mock_usuario):
    mock_usuario.query.all.side_effect = Exception("DB error")
    erro, usuarios = usuario.listar_usuarios()
    assert "DB error" in erro
    assert usuarios is None


# =================== cria_usuario ===================

@patch("app.services.usuario.db")
@patch("app.services.usuario.Usuario")
def test_cria_usuario_sucesso(mock_usuario, mock_db):
    mock_usuario.query.filter_by.return_value.first.return_value = None
    novo_user = MagicMock()
    mock_usuario.return_value = novo_user

    data = {
        "nome": "João",
        "email": "joao@test.com",
        "funcao": "Técnico",
        "setor": "Manutenção",
        "senha": "1234"
    }

    erro, user = usuario.cria_usuario(data)

    assert erro is None
    mock_db.session.add.assert_called_once_with(novo_user)
    mock_db.session.commit.assert_called_once()
    novo_user.set_senha.assert_called_once_with("1234")
    assert user == novo_user


@patch("app.services.usuario.Usuario")
def test_cria_usuario_email_existente(mock_usuario):
    mock_usuario.query.filter_by.return_value.first.return_value = True
    data = {
        "nome": "Maria",
        "email": "maria@test.com",
        "funcao": "Técnica",
        "setor": "Manutenção",
        "senha": "1234"
    }

    erro, user = usuario.cria_usuario(data)
    assert "já cadastrado" in erro
    assert user is None


@patch("app.services.usuario.db")
@patch("app.services.usuario.Usuario")
def test_cria_usuario_excecao_commit(mock_usuario, mock_db):
    mock_usuario.query.filter_by.return_value.first.return_value = None
    mock_db.session.commit.side_effect = Exception("Falha commit")

    data = {
        "nome": "Pedro",
        "email": "pedro@test.com",
        "funcao": "Supervisor",
        "setor": "TI",
        "senha": "4321"
    }

    erro, user = usuario.cria_usuario(data)
    assert "Falha commit" in erro
    mock_db.session.rollback.assert_called_once()
    assert user is None


# =================== atualiza_usuario ===================

@patch("app.services.usuario.db")
@patch("app.services.usuario.Usuario")
def test_atualiza_usuario_sucesso(mock_usuario, mock_db):
    mock_instance = MagicMock()
    mock_usuario.query.get.return_value = mock_instance

    data = {"nome": "Novo Nome", "setor": "TI", "senha": "nova123"}
    erro = usuario.atualiza_usuario(1, data)

    assert erro is None
    mock_instance.set_senha.assert_called_once_with("nova123")
    mock_db.session.commit.assert_called_once()


@patch("app.services.usuario.Usuario")
def test_atualiza_usuario_nao_encontrado(mock_usuario):
    mock_usuario.query.get.return_value = None
    erro, _ = usuario.atualiza_usuario(999, {})
    assert "não encontrado" in erro


@patch("app.services.usuario.db")
@patch("app.services.usuario.Usuario")
def test_atualiza_usuario_excecao(mock_usuario, mock_db):
    mock_instance = MagicMock()
    mock_usuario.query.get.return_value = mock_instance
    mock_db.session.commit.side_effect = Exception("Erro commit")

    erro = usuario.atualiza_usuario(1, {"nome": "Teste"})
    assert "Erro commit" in erro
    mock_db.session.rollback.assert_called_once()


# =================== deleta_usuario ===================

@patch("app.services.usuario.db")
@patch("app.services.usuario.Usuario")
def test_deleta_usuario_sucesso(mock_usuario, mock_db):
    mock_inst = MagicMock()
    mock_usuario.query.get.return_value = mock_inst

    erro = usuario.deleta_usuario(1)
    assert erro is None
    mock_db.session.delete.assert_called_once_with(mock_inst)
    mock_db.session.commit.assert_called_once()


@patch("app.services.usuario.Usuario")
def test_deleta_usuario_nao_encontrado(mock_usuario):
    mock_usuario.query.get.return_value = None
    erro, _ = usuario.deleta_usuario(999)
    assert "não encontrado" in erro


@patch("app.services.usuario.db")
@patch("app.services.usuario.Usuario")
def test_deleta_usuario_excecao(mock_usuario, mock_db):
    mock_inst = MagicMock()
    mock_usuario.query.get.return_value = mock_inst
    mock_db.session.commit.side_effect = Exception("Falha deletar")

    erro = usuario.deleta_usuario(1)
    assert "Falha deletar" in erro
    mock_db.session.rollback.assert_called_once()
