FROM python:3.10-slim

WORKDIR /app

# Instala Java y dependencias
USER root
RUN apt-get update && apt-get install -y wget curl tar && \
    wget https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.10+7/OpenJDK17U-jre_x64_linux_hotspot_17.0.10_7.tar.gz \
    && mkdir -p /opt/java/openjdk \
    && tar -xzf OpenJDK17U-jre_x64_linux_hotspot_17.0.10_7.tar.gz -C /opt/java/openjdk --strip-components=1 \
    && rm OpenJDK17U-jre_x64_linux_hotspot_17.0.10_7.tar.gz \
    && pip install --no-cache-dir pyspark pandas kafka-python

ENV JAVA_HOME=/opt/java/openjdk
ENV PATH=$JAVA_HOME/bin:$PATH
ENV PYSPARK_PYTHON=python3
ENV PYSPARK_DRIVER_PYTHON=python3

# Copia el main.py directamente
COPY main.py /app/

CMD ["python", "main.py"]

