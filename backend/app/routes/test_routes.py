import pytest
from unittest.mock import patch
from app import create_app


@pytest.fixture
def client():
    """Cria app Flask em modo de teste."""
    app = create_app("testing")
    app.config["TESTING"] = True
    client = app.test_client()
    return client


# =================== HOME ====================

def test_home(client):
    response = client.get("/")
    assert response.status_code == 200
    assert "Aplicação Flask" in response.data.decode("utf-8")



# =================== LOGIN ====================

@patch("app.routes.routes.autenticar_usuario")
def test_login_sucesso(mock_autenticar, client):
    mock_autenticar.return_value = (None, type("UsuarioMock", (), {"to_dict": lambda self: {"id": 1, "nome": "João"}})())

    response = client.post("/login", json={"email": "teste", "senha": "123"})
    assert response.status_code == 200
    assert response.get_json()["nome"] == "João"


@patch("app.routes.routes.autenticar_usuario")
def test_login_falha(mock_autenticar, client):
    mock_autenticar.return_value = ("Credenciais inválidas", None)

    response = client.post("/login", json={"email": "errado", "senha": "xxx"})
    assert response.status_code == 401
    assert "erro" in response.get_json()


# =================== USUÁRIOS ====================

@patch("app.routes.routes.listar_usuarios")
def test_listar_usuarios_sucesso(mock_listar, client):
    usuario_mock = type("UsuarioMock", (), {"to_dict": lambda self: {"id": 1, "nome": "João"}})()
    mock_listar.return_value = (None, [usuario_mock])
    response = client.get("/usuarios")
    assert response.status_code == 200
    assert response.get_json()[0]["nome"] == "João"


@patch("app.routes.routes.cria_usuario")
def test_criar_usuario_sucesso(mock_criar, client):
    usuario_mock = type("UsuarioMock", (), {"to_dict": lambda self: {"id": 1, "nome": "Maria"}})()
    mock_criar.return_value = (None, usuario_mock)

    data = {"nome": "Maria", "email": "maria@test", "funcao": "Téc", "setor": "Mecânica", "senha": "123"}
    response = client.post("/usuarios", json=data)
    assert response.status_code == 201
    assert response.get_json()["nome"] == "Maria"


@patch("app.routes.routes.cria_usuario")
def test_criar_usuario_email_existente(mock_criar, client):
    mock_criar.return_value = ("Email já cadastrado.", None)
    data = {"nome": "João", "email": "joao@test", "funcao": "Téc", "setor": "Mecânica", "senha": "123"}
    response = client.post("/usuarios", json=data)
    assert response.status_code == 400
    assert "erro" in response.get_json()


# =================== PEÇAS ====================

@patch("app.routes.routes.listar_pecas")
def test_listar_pecas(mock_listar, client):
    estoque_mock = type("EstoqueMock", (), {"to_dict": lambda self: {"id": 1, "peca": "Parafuso"}})()
    mock_listar.return_value = (None, [estoque_mock])

    response = client.get("/peca")
    assert response.status_code == 200
    assert response.get_json()[0]["peca"] == "Parafuso"


@patch("app.routes.routes.nova_peca")
def test_nova_peca_sucesso(mock_nova, client):
    estoque_mock = type("EstoqueMock", (), {"to_dict": lambda self: {"id": 1, "peca": "Motor"}})()
    mock_nova.return_value = (None, estoque_mock)

    response = client.post("/peca", json={"nome": "Motor", "categoria": "Elétrica", "qtd": 10, "qtd_min": 2})
    assert response.status_code == 201
    assert response.get_json()["peca"] == "Motor"


@patch("app.routes.routes.excluir_peca")
def test_excluir_peca_sucesso(mock_excluir, client):
    mock_excluir.return_value = None
    response = client.delete("/peca/1")
    assert response.status_code == 200
    assert "mensagem" in response.get_json()


# =================== ORDENS DE SERVIÇO ====================

@patch("app.routes.routes.listar_ordens")
def test_listar_ordens(mock_listar, client):
    ordem_mock = type("OrdemMock", (), {"to_dict": lambda self: {"id": 1, "tipo": "Corretiva"}})()
    mock_listar.return_value = (None, [ordem_mock])

    response = client.get("/ordemservico")
    assert response.status_code == 200
    assert response.get_json()[0]["tipo"] == "Corretiva"


@patch("app.routes.routes.nova_ordem")
def test_nova_ordem_sucesso(mock_nova, client):
    ordem_mock = type("OrdemMock", (), {"to_dict": lambda self: {"id": 99, "tipo": "Preventiva"}})()
    mock_nova.return_value = (None, ordem_mock)

    response = client.post("/ordemservico", json={"tipo": "Preventiva"})
    assert response.status_code == 201
    assert response.get_json()["tipo"] == "Preventiva"


@patch("app.routes.routes.excluir_ordem")
def test_excluir_ordem_sucesso(mock_excluir, client):
    mock_excluir.return_value = (None, None)
    response = client.delete("/ordemservico/1")
    assert response.status_code == 200
    assert "mensagem" in response.get_json()


# =================== ALERTAS ====================

@patch("app.routes.routes.listar_alertas_reposicao")
def test_alertas_estoque(mock_alertas, client):
    mock_alertas.return_value = (None, [])
    response = client.get("/estoque/alertas")
    assert response.status_code == 200


@patch("app.routes.routes.listar_notificacoes")
def test_listar_notificacoes(mock_notif, client):
    mock_notif.return_value = ("ok", 200)
    response = client.get("/estoque/notificacoes")
    assert response.status_code == 200
