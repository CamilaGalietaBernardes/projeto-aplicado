from werkzeug.security import generate_password_hash, check_password_hash
from .. import db

class Estoque(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    peca = db.Column(db.String(100), nullable=False)
    qtd = db.Column(db.Integer, nullable=False)
    categoria = db.Column(db.String(100), nullable=False)

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
    id = db.Column(db.Integer, primary_key=True)
    solicitante = db.Column(db.Integer, db.ForeignKey('usuario.id'), nullable=False)
    setor = db.Column(db.String(100), nullable=False)  
    data = db.Column(db.DateTime, nullable=False) 
    recorrencia = db.Column(db.String(50), nullable=False)  
    detalhes = db.Column(db.Text, nullable=True)  
    status = db.Column(db.String(50), nullable=False)  

    solicitante_id = db.Column(db.Integer, db.ForeignKey('usuario.id'), nullable=False)

    solicitante = db.relationship('Usuario', backref='ordens_servico', foreign_keys=[solicitante_id])

class Pecas_Ordem_Servico(db.Model):
    os_id = db.Column(db.Integer, db.ForeignKey('ordem_servico.id'), primary_key = True)
    peca_id = db.Column(db.Integer, db.ForeignKey('estoque.id'), primary_key=True)

    ordem_servico = db.relationship("OrdemServico", backref="ordem_pecas")
    peca = db.relationship("Estoque", backref="ordem_pecas")