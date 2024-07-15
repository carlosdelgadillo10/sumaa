# division/Dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY . /app

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8085
CMD ["uvicorn", "app.suma:app", "--host", "127.0.0.1", "--port", "8085"]
