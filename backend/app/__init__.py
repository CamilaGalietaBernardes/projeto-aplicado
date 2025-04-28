from flask import Flask
from app.routes import main
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)

    app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:mikecaio01@localhost/gestao_estoque_manutencao'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

    db.init_app(app)

    from .models import Estoque, Usuario, OrdemServico
    with app.app_context():
        db.create_all()

    from .routes import main
    app.register_blueprint(main)

    return app