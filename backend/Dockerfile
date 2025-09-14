# Dockerfile na pasta backend

FROM python:3.9

WORKDIR /app

# Copia o requirements.txt para a raiz do diretório de trabalho do contêiner
COPY requirements.txt .

# Instala as dependências a partir do arquivo copiado
RUN pip install --no-cache-dir -r requirements.txt

# Copia o resto dos arquivos
COPY . .

EXPOSE 5000