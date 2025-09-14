FROM python:3.9

# Define o diretório de trabalho
WORKDIR /app

# Copia e instala o requirements.txt primeiro para cache
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia o restante do código
COPY backend/ .

EXPOSE 5000

# Comando para iniciar a aplicação
CMD gunicorn --bind 0.0.0.0:$PORT 'wsgi:app'