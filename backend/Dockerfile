FROM python:3.9

# Define o diretório de trabalho
WORKDIR /app

# Copia todo o conteúdo da pasta backend para o contêiner (que é o diretório de trabalho /app)
# Isso inclui requirements.txt, que será usado logo em seguida.
COPY backend/ .

# Instala as dependências a partir do arquivo no diretório atual.
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

# O CMD assume que a aplicação está configurada para rodar com gunicorn e que a porta é passada pela variável de ambiente $PORT
CMD gunicorn --bind 0.0.0.0:$PORT 'wsgi:app'
