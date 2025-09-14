import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

# Adicione esta linha para depuração
print("Iniciando a criação da aplicação...")

db = SQLAlchemy()

def create_app() -> Flask:
    # Adicione esta linha
    print("Tentando criar a aplicação Flask...")
    app = Flask(__name__)

    uri = os.getenv("DATABASE_URL")
    
    # Adicione esta linha
    print(f"URI do banco de dados obtida: {uri}")

    if uri and uri.startswith("postgres://"):
        uri = uri.replace("postgres://", "postgresql://", 1)

    app.config["SQLALCHEMY_DATABASE_URI"] = uri

    # Adicione esta linha
    print("Configurando o CORS e o SQLAlchemy...")
    CORS(app)
    db.init_app(app)

    # Adicione esta linha
    print("Importando rotas e modelos...")
    from routes import routes
    app.register_blueprint(routes.bp)
    from models import models as _models
    
    # Adicione esta linha
    print("Verificando se o banco de dados está disponível...")
    with app.app_context():
        try:
            db.create_all()
            # Adicione esta linha
            print("✅ Tabelas criadas com sucesso! A aplicação deve iniciar agora.")
        except Exception as e:
            # Esta linha é crucial para o diagnóstico
            print(f"❌ Erro de conexão com o banco de dados: {e}")
            raise  # Levanta a exceção para que o Render a capture

    return app

app = create_app()