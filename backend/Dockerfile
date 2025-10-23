FROM python:3.9


WORKDIR /app

COPY . .


RUN chmod +x ./wait-for-db.sh
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 6000

CMD sh -c "./wait-for-db.sh && flask run --host=0.0.0.0  --port=6000 --reload"

