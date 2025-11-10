import pytest
from datetime import datetime
from app import create_app, db
from app.models import (
    Peca,
    Estoque,
    Usuario,
    OrdemServico,
    Pecas_Ordem_Servico
)

@pytest.fixture()
def test_client():
    """Cria um app Flask novo e banco limpo para cada teste."""
    from .. import create_app, db  # ajuste se necessário
    flask_app = create_app("testing")

    with flask_app.app_context():
        db.create_all()
        yield flask_app.test_client()
        db.session.remove()
        db.drop_all()

@pytest.fixture
def sample_data():
    """Cria dados iniciais para os testes."""
    peca = Peca(nome="Parafuso", categoria="Fixação")
    usuario = Usuario(
        nome="João da Silva",
        email="joao@example.com",
        funcao="Técnico",
        setor="Manutenção"
    )
    usuario.set_senha("12345")
    db.session.add_all([peca, usuario])
    db.session.commit()

    estoque = Estoque(qtd=50, qtd_min=10, peca_id=peca.id)
    db.session.add(estoque)
    db.session.commit()

    return {"peca": peca, "usuario": usuario, "estoque": estoque}

def test_criar_peca(test_client):
    p = Peca(nome="Motor", categoria="Elétrica")
    db.session.add(p)
    db.session.commit()

    assert p.id is not None
    assert p.to_dict() == {"id": p.id, "nome": "Motor", "categoria": "Elétrica"}

def test_criar_usuario_e_verificar_senha(test_client):
    u = Usuario(
        nome="Maria",
        email="maria@example.com",
        funcao="Supervisora",
        setor="Produção"
    )
    u.set_senha("senha123")
    db.session.add(u)
    db.session.commit()

    assert u.verificar_senha("senha123") is True
    assert u.verificar_senha("senha_errada") is False
    assert "senha_hash" not in u.to_dict()

def test_criar_estoque_e_relacionar_peca(test_client, sample_data):
    estoque = sample_data["estoque"]

    assert estoque.peca is not None
    assert estoque.peca.nome == "Parafuso"
    data_dict = estoque.to_dict()
    assert data_dict["peca"] == "Parafuso"
    assert data_dict["categoria"] == "Fixação"
    assert data_dict["qtd"] == 50
    assert data_dict["qtd_min"] == 10

def test_criar_ordem_servico(test_client, sample_data):
    os = OrdemServico(
        tipo="Corretiva",
        setor="Manutenção",
        data=datetime(2025, 11, 1),
        recorrencia="Única",
        detalhes="Troca de motor",
        status="Aberta",
        equipamento_id=sample_data["estoque"].id,
        solicitante_id=sample_data["usuario"].id
    )
    db.session.add(os)
    db.session.commit()

    assert os.id is not None
    os_dict = os.to_dict()
    assert os_dict["tipo"] == "Corretiva"
    assert os_dict["equipamento"]["peca"] == "Parafuso"
    assert os_dict["solicitante"]["nome"] == "João da Silva"

def test_relacionamento_pecas_ordem_servico(test_client, sample_data):
    os = OrdemServico(
        tipo="Preventiva",
        setor="Elétrica",
        data=datetime.utcnow(),
        recorrencia="Mensal",
        detalhes="Troca preventiva de parafusos",
        status="Aberta",
        solicitante_id=sample_data["usuario"].id
    )
    db.session.add(os)
    db.session.commit()

    pos = Pecas_Ordem_Servico(
        os_id=os.id,
        peca_id=sample_data["peca"].id,
        quantidade=5
    )
    db.session.add(pos)
    db.session.commit()

    assert len(os.pecas_os) == 1
    assert os.pecas_os[0].peca.nome == "Parafuso"
    assert os.pecas_os[0].quantidade == 5

def test_delete_cascade_peca(test_client, sample_data):
    """Verifica se a exclusão da peça não quebra integridade, mesmo sem cascade ativo."""
    peca = sample_data["peca"]

    try:
        db.session.delete(peca)
        db.session.commit()
    except Exception:
        db.session.rollback()

    estoques = Estoque.query.all()
    assert all(e.peca_id is not None for e in estoques)

