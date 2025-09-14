FROM python:3.9

# Copia o requirements.txt para o diretório de trabalho da aplicação
WORKDIR /app
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia o restante do código para o diretório de trabalho
COPY backend/ .

EXPOSE 5000