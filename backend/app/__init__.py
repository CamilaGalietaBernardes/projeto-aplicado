import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

from dotenv import load_dotenv
load_dotenv(override=False)

db = SQLAlchemy()


def create_app() -> Flask:

    app = Flask(__name__)

    DB_USER = os.getenv('DB_USER', 'camila_pa')
    DB_PASSWORD = os.getenv('DB_PASSWORD', 'projeto_aplicado')
    DB_HOST = os.getenv('DB_HOST', 'db')
    DB_PORT = os.getenv('DB_PORT', '5432')
    DB_NAME = os.getenv('DB_NAME', 'gestao_estoque_manutencao')

    app.config["SQLALCHEMY_DATABASE_URI"] = (
        f"postgresql+psycopg://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    )

    app.config["SQLALCHEMY_ECHO"] = bool(int(os.getenv("SQLALCHEMY_ECHO", "0")))
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    CORS(
        app,
        resources={r"/*": {"origins": ["http://localhost:5173"]}},
        methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],
        allow_headers=["Content-Type", "Authorization"],
    )

    db.init_app(app)

    from .routes import routes
    app.register_blueprint(routes.bp)

    from .models import models as _models

    with app.app_context():
        db.create_all() 
        print("Tabelas criadas com sucesso!")

    return app
