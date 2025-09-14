import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from dotenv import load_dotenv

# Carrega as variáveis de ambiente do .env
load_dotenv(override=False)

# Instancia o aplicativo Flask e o SQLAlchemy
app = Flask(__name__)
db = SQLAlchemy()

# Configurações do aplicativo
app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv("DATABASE_URL")
app.config["SQLALCHEMY_ECHO"] = bool(int(os.getenv("SQLALCHEMY_ECHO", "0")))
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

# Configura o CORS
CORS(
    app,
    resources={r"/*": {"origins": ["http://localhost:5173"]}},
    methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allow_headers=["Content-Type", "Authorization"],
)

# Inicializa o db e registra as rotas
db.init_app(app)
from .routes import routes
app.register_blueprint(routes.bp)

# Cria as tabelas do banco de dados ao iniciar
with app.app_context():
    db.create_all()
    print("Tabelas criadas com sucesso!")

# O Gunicorn agora pode encontrar a variável 'app' no módulo backend.app