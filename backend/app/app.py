import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

def create_app() -> Flask:
    print("1. Tentando criar a aplicacao Flask...")
    app = Flask(__name__)

    uri = os.getenv("DATABASE_URL")
    print(f"2. URI do banco de dados: {uri}")

    if uri and uri.startswith("postgres://"):
        uri = uri.replace("postgres://", "postgresql://", 1)

    app.config["SQLALCHEMY_DATABASE_URI"] = uri

    print("3. Inicializando o banco de dados...")
    db = SQLAlchemy(app) # Crie a instancia do SQLAlchemy aqui
    
    print("4. Configurando CORS e outras dependencias...")
    CORS(app)

    print("5. Importando rotas e modelos...")
    # Verifique os nomes dos arquivos e pastas aqui
    from routes import routes 
    from models import models as _models
    
    app.register_blueprint(routes.bp)

    print("6. Tentando criar as tabelas do banco de dados...")
    try:
        with app.app_context():
            db.create_all()
            print("🎉 Tabelas criadas com sucesso!")
    except Exception as e:
        print(f"❌ Erro fatal: {e}")
        raise # Levanta a excecao para o log do Render

    print("7. Aplicacao pronta para ser retornada.")
    return app