FROM bitnami/spark:3.4.1

USER root
WORKDIR /app

# Instalar curl (necesario para descargar los JARs)
RUN install_packages curl

# Crear carpeta para los JARs
RUN mkdir -p /app/jars

# Descargar los JARs necesarios para Kafka-Spark integration
RUN curl -o /app/jars/spark-sql-kafka-0-10_2.12-3.4.1.jar \
    https://repo1.maven.org/maven2/org/apache/spark/spark-sql-kafka-0-10_2.12/3.4.1/spark-sql-kafka-0-10_2.12-3.4.1.jar && \
    curl -o /app/jars/kafka-clients-3.4.0.jar \
    https://repo1.maven.org/maven2/org/apache/kafka/kafka-clients/3.4.0/kafka-clients-3.4.0.jar && \
    curl -o /app/jars/commons-pool2-2.11.1.jar \
    https://repo1.maven.org/maven2/org/apache/commons/commons-pool2/2.11.1/commons-pool2-2.11.1.jar && \
    curl -o /app/jars/spark-token-provider-kafka-0-10_2.12-3.4.1.jar \
    https://repo1.maven.org/maven2/org/apache/spark/spark-token-provider-kafka-0-10_2.12/3.4.1/spark-token-provider-kafka-0-10_2.12-3.4.1.jar

# Instalar dependencias Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el código de la aplicación
COPY app/jobs/ ./jobs/

# Ejecutar el streaming job con los JARs incluidos
CMD ["spark-submit", \
    "--jars", "/app/jars/spark-sql-kafka-0-10_2.12-3.4.1.jar,/app/jars/kafka-clients-3.4.0.jar,/app/jars/commons-pool2-2.11.1.jar,/app/jars/spark-token-provider-kafka-0-10_2.12-3.4.1.jar", \
    "--master", "spark://spark-master:7077", \
    "jobs/streaming_job.py"]
