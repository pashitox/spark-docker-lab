FROM bitnami/spark:3.4.1

# Metadatos
LABEL maintainer="pashitox <pashitox@mail.com>"
LABEL version="1.0.0"
LABEL description="Spark Streaming Application with Kafka"

# Variables de entorno
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app
ENV SPARK_HOME=/opt/bitnami/spark

# Instalar dependencias del sistema
USER root

# ¡CREAR EL DIRECTORIO DE EVENTOS QUE FALTA!
RUN mkdir -p /opt/bitnami/spark/events && \
    chown -R 1001:1001 /opt/bitnami/spark/events && \
    mkdir -p /var/lib/apt/lists/partial && \
    apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

# Crear estructura de directorios
RUN mkdir -p /app/jobs /app/utils /logs && \
    chown -R 1001:1001 /app /logs

# Copiar requirements primero (para cache de Docker)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Crear directorio de configuracion si no existe
RUN mkdir -p ${SPARK_HOME}/conf

# Copiar código de la aplicación
COPY app/ /app/
COPY config/spark-defaults.conf ${SPARK_HOME}/conf/

# Permisos y ownership
RUN chown -R 1001:1001 /app && \
    chmod -R 755 /app

# Cambiar a usuario no-root existente (Bitnami)
USER 1001

WORKDIR /app

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:4040/ || exit 1

# Comando por defecto
CMD spark-submit \
    --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.4.1 \
    --master spark://spark-master:7077 \
    /app/jobs/streaming_job.py