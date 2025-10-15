FROM python:3.9

WORKDIR /app

COPY requirements.txt app/requirements.txt

RUN pip install --no-cache-dir -r app/requirements.txt

COPY wait-for-db.sh /app/wait-for-db.sh
RUN chmod +x /app/wait-for-db.sh

COPY . /app

EXPOSE 5000