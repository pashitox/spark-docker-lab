#!/usr/bin/env python3
print("🚀 Spark Simple App")

import sys
sys.path.insert(0, "/opt/bitnami/spark/python")
sys.path.insert(0, "/opt/bitnami/spark/python/lib/py4j-0.10.9.7-src.zip")

try:
    from pyspark.sql import SparkSession
    
    # Modo local seguro
    spark = SparkSession.builder \
        .appName("SimpleTest") \
        .master("local[*]") \
        .config("spark.driver.memory", "512m") \
        .getOrCreate()
    
    print("✅ Spark funciona!")
    
    # Leer datos
    df = spark.read.csv("/data/batch/clientes.csv", header=True, inferSchema=True)
    print(f"✅ Datos leídos: {df.count()} filas")
    df.show(5)
    
    spark.stop()
    print("✅ Completado!")
    
except Exception as e:
    print(f"❌ Error: {e}")
    import traceback
    traceback.print_exc()
