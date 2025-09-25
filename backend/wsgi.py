import os
from dotenv import load_dotenv

# Carrega as variáveis de ambiente (necessário para a fábrica de app)
load_dotenv(override=False)

# Importa a função de fábrica de aplicativo
from app import create_app

# Cria a instância da aplicação que o Gunicorn vai executar
app = create_app()