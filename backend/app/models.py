from app import db

#Tabela Estoque
class Estoque(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    peca = db.Column(db.String(100), nullable=False)
    qtd = db.Column(db.Integer, nullable=False)
    categoria = db.Column(db.String(100), nullable=False)

class Usuario(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    nome = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100), nullable=False)
    funcao = db.Column(db.String(100), nullable=False)
    setor = db.Column(db.String(100), nullable=False)

class OrdemServico(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    solicitante = db.Column(db.Integer, db.ForeignKey('usuario.id'), nullable=False)
    pecas = db.Column(db.Integer, db.ForeignKey('estoque.id'), nullable=False) 
    setor = db.Column(db.String(100), nullable=False)  
    data = db.Column(db.DateTime, nullable=False) 
    recorrencia = db.Column(db.String(50), nullable=False)  
    detalhes = db.Column(db.Text, nullable=True)  
    status = db.Column(db.String(50), nullable=False)  

    solicitante = db.relationship('Usuario', backref='ordem_servico', foreign_keys=[solicitante])
    pecas = db.relationship('Estoque', backref='ordem_servico', foreign_keys=[pecas])