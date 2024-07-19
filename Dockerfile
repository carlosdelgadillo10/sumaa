# sumaa/Dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY . /app

RUN pip install --no-cache-dir -r requirements.txt

# Definir una variable de entorno para configurar el puerto
ENV PUERTO=8085
#Esta es la configuración por defecto que se usará si el usuario no especifica otra mediante una variable de entorno al ejecutar el contenedor.

# Exponer el puerto especificado por la variable de entorno PUERTO
EXPOSE $PUERTO

# Comando por defecto para ejecutar la aplicación usando Uvicorn, usando la variable de entorno para el puerto
CMD ["uvicorn", "app.suma:app", "--host", "0.0.0.0", "--port", "8085"]
#escuchar en 0.0.0.0, significa que está dispuesto a recibir conexiones desde cualquier dirección IP disponible en la máquina host
