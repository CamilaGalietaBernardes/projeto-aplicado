import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from dotenv import load_dotenv

load_dotenv(override=False)

db = SQLAlchemy()

def create_app() -> Flask:
    app = Flask(__name__)

    uri = os.getenv("DATABASE_URL") or os.getenv("SQLALCHEMY_DATABASE_URI")
    if uri and uri.startswith("postgres://"):
        uri = uri.replace("postgres://", "postgresql://", 1)

    app.config["SQLALCHEMY_DATABASE_URI"] = uri
    app.config["SQLALCHEMY_ECHO"] = bool(int(os.getenv("SQLALCHEMY_ECHO", "0")))
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    CORS(app)
    db.init_app(app)

    # Note: você pode precisar ajustar essas importações
    # de `from .routes import routes` para algo como `from routes import routes`
    # dependendo da sua estrutura de pastas.
    from .routes import routes
    app.register_blueprint(routes.bp)

    from .models import models as _models

    with app.app_context():
        db.create_all()
        print("Tabelas criadas com sucesso!")

    return app

# Adicione o objeto 'app' que o Gunicorn espera
app = create_app()