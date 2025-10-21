import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

from dotenv import load_dotenv

mode = os.getenv("APP_MODE", "local")
env_file = f".env.{mode}"
load_dotenv(env_file, override=False)

db = SQLAlchemy()

def create_app() -> Flask:
    app = Flask(__name__)

    app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv("DATABASE_URL")
    app.config["SQLALCHEMY_ECHO"] = bool(int(os.getenv("SQLALCHEMY_ECHO", "0")))
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    frontend_origins = os.getenv("FRONTEND_ORIGINS", "http://localhost:5173").split(",")
    frontend_origins = [o.strip() for o in frontend_origins if o.strip()]

    CORS(
        app,
        resources={r"/*": {"origins": frontend_origins}},
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