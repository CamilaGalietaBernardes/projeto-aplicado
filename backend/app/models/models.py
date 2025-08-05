from werkzeug.security import generate_password_hash, check_password_hash
from .. import db

class Peca(db.Model):
    __tablename__ = 'peca'

    id = db.Column(db.Integer, primary_key=True)
    nome = db.Column(db.String(100), nullable=False)
    categoria = db.Column(db.String(100), nullable=False)

    def to_dict(self):
        return {
            "id": self.id,
            "nome": self.nome,
            "categoria": self.categoria
        }

class Estoque(db.Model):
    __tablename__ = 'estoque'

    id = db.Column(db.Integer, primary_key=True)
    qtd = db.Column(db.Integer, nullable=False)
    qtd_min = db.Column(db.Integer, nullable=False)
    peca_id = db.Column(
        db.Integer, 
        db.ForeignKey('peca.id', ondelete='CASCADE'), 
        nullable = False
    )
    peca = db.relationship('Peca', backref=db.backref('estoques', passive_deletes=True))

    def to_dict(self):
        return {
            "id": self.id,
            "peca": self.peca.nome if self.peca else None,
            "categoria": self.peca.categoria if self.peca.categoria else None,
            "qtd": self.qtd,
            "qtd_min": self.qtd_min
        }

class Usuario(db.Model):
    __tablename__ = 'usuario'

    id = db.Column(db.Integer, primary_key = True)
    nome = db.Column(db.String(100), nullable = False)
    email = db.Column(db.String(100), unique = True, nullable = False)
    funcao = db.Column(db.String(100), nullable = False)
    setor = db.Column(db.String(100), nullable = False)
    senha_hash = db.Column(db.String(512), nullable = False)

    def set_senha(self, senha):
        self.senha_hash = generate_password_hash(senha)

    def verificar_senha(self, senha):
        return check_password_hash(self.senha_hash, senha)
    
    def to_dict(self):
        return {
            "id" : self.id,
            "nome" : self.nome,
            "email" : self.email,
            "funcao" : self.funcao,
            "setor" : self.setor,
        }

class OrdemServico(db.Model):
    __tablename__ = 'ordem_servico'

    id = db.Column(db.Integer, primary_key=True)
    tipo = db.Column(db.String(100), nullable=False)
    setor = db.Column(db.String(100), nullable=False)  
    data = db.Column(db.DateTime, nullable=False) 
    recorrencia = db.Column(db.String(50), nullable=False)  
    detalhes = db.Column(db.Text, nullable=True)  
    status = db.Column(db.String(50), nullable=False)  
   
    equipamento_id = db.Column(db.Integer, db.ForeignKey('estoque.id'), nullable=True)
    solicitante_id = db.Column(db.Integer, db.ForeignKey('usuario.id'), nullable=False)
    
    equipamento = db.relationship('Estoque', backref='ordens_servico')
    solicitante = db.relationship('Usuario', backref='ordens_servico')

    def to_dict(self):
        return{
            "id": self.id,
            "tipo": self.tipo,
            "setor": self.setor,
            "recorrencia": self.recorrencia,
            "detalhes": self.detalhes, 
            "status": self.status,
            "equipamento": self.equipamento.to_dict() if self.equipamento else None,
            "solicitante": self.solicitante.to_dict() if self.solicitante else None

        }

class Pecas_Ordem_Servico(db.Model):
    __tablename__ = 'pecas_ordems_servico'

    os_id = db.Column(db.Integer, db.ForeignKey('ordem_servico.id', ondelete='CASCADE'), primary_key = True)
    peca_id = db.Column(db.Integer, db.ForeignKey('peca.id', ondelete='CASCADE'), primary_key=True)
    quantidade = db.Column(db.Integer, nullable=False)

    ordem_servico = db.relationship("OrdemServico", backref="pecas_os")
    peca = db.relationship("Peca", backref="usada_em_ordens")

    