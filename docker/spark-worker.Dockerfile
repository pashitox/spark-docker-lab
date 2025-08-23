FROM bitnami/spark:3.5.1

# Configurar Python 3.9 (que ya viene instalado en la imagen)
USER root
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    ln -sf /usr/bin/python3 /usr/bin/python

# Configurar variables de entorno para Python 3
ENV PYSPARK_PYTHON=python3
ENV PYSPARK_DRIVER_PYTHON=python3

USER 1001