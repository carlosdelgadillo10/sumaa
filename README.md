# Suma API

Esta es una aplicación FastAPI simple que proporciona un endpoint para realizar operaciones de suma. La aplicación está configurada para ejecutarse en un contenedor Docker.

## Contenidos

- **`app/suma.py`**: Código fuente de la aplicación FastAPI.
- **`sumaa/Dockerfile`**: Dockerfile para construir la imagen Docker de la aplicación.

## Requisitos

Antes de comenzar, asegúrate de tener Docker instalado en tu sistema. Puedes descargarlo desde [Docker](https://www.docker.com/products/docker-desktop).

SI quieres correr la imagen docker:
docker run -p 8085:8085 carlosdelgadillo/sumaa:latest

Para ejecutar la aplicación, sigue estos pasos:

### 1. Clona el Repositorio

Si aún no tienes el repositorio, clónalo usando Git si lo quieres probar localmente:

```bash
git clone https://github.com/carlosdelgadillo10/sumaa.git
cd <carpeta donde lo clonaste>
docker build -t suma-api .
docker run -d -p 8085:8085 suma-api





