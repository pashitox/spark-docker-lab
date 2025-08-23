# Dockerfile para la app PySpark
FROM python:3.10-slim

# Instalar Java y Spark
RUN apt-get update && apt-get install -y openjdk-11-jdk wget curl && \
    pip install --no-cache-dir pyspark pandas kafka-python

WORKDIR /app

# Copiar el código
COPY . /app

# Comando por defecto (puede cambiar según tu main.py)
CMD ["python", "main.py"]

