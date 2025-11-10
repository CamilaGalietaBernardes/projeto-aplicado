import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from dotenv import load_dotenv

mode = os.getenv("APP_MODE", "local")
env_file = f".env.{mode}"
load_dotenv(env_file, override=False)

db = SQLAlchemy()

def create_app(config_name="default") -> Flask:
    app = Flask(__name__)

    app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv("DATABASE_URL")
    app.config["SQLALCHEMY_ECHO"] = bool(int(os.getenv("SQLALCHEMY_ECHO", "0")))
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    frontend_origins = os.getenv(
        "FRONTEND_ORIGINS",
        "http://localhost:5173,https://projeto-aplicado-front.onrender.com,https://projeto-aplicado-frontend.web.app"
    ).split(",")

    frontend_origins = [origin.strip() for origin in frontend_origins if origin.strip()]

    CORS(
        app,
        resources={r"/*": {"origins": frontend_origins}},
        methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],
        allow_headers=["Content-Type", "Authorization"],
        supports_credentials=True
    )

    from .config import TestingConfig
    if config_name == "testing":
        app.config.from_object(TestingConfig)
    db.init_app(app)

    from .routes import routes
    app.register_blueprint(routes.bp)

    from .models import models as _models

    with app.app_context():
        db.create_all()
        print("Tabelas criadas com sucesso!")

    return app
