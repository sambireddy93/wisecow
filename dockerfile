FROM python:3.9-slim

WORKDIR /app
COPY . /app

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 4499

# Use your shell script as entrypoint for this project
ENTRYPOINT ["./start.sh"]
