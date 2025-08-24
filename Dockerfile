# Dockerfile para Render - Spark Streaming
FROM bitnami/spark:3.4.1

LABEL maintainer="pashitox <pashitox@mail.com>"
LABEL version="1.0.0"
LABEL description="Spark Streaming Application with Kafka (Render deploy)"

# Variables de entorno
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app
ENV SPARK_HOME=/opt/bitnami/spark

# Usuario root para instalar dependencias
USER root

# Crear directorios necesarios y permisos
RUN mkdir -p /opt/bitnami/spark/events && chmod -R 777 /opt/bitnami/spark/events
RUN mkdir -p /app/jobs /app/utils /logs && chown -R 1001:1001 /app /logs

# Instalar dependencias Python
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copiar código de la aplicación
COPY app/ /app/
COPY config/spark-defaults.conf ${SPARK_HOME}/conf/

# Cambiar permisos de la aplicación
RUN chown -R 1001:1001 /app && chmod -R 755 /app

# Cambiar a usuario no-root
USER 1001

WORKDIR /app

# Health check simple
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:4040/ || exit 1

# Comando por defecto: Spark en modo local
CMD spark-submit \
    --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.4.1 \
    /app/jobs/streaming_job.py

