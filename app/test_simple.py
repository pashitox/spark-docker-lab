#!/usr/bin/env python3
import sys
sys.path.insert(0, '/opt/bitnami/spark/python')
sys.path.insert(0, '/opt/bitnami/spark/python/lib/py4j-0.10.9.7-src.zip')

def test_spark():
    try:
        from pyspark.sql import SparkSession
        
        print("🧪 Probando conexión básica a Spark...")
        
        # Configuración mínima y robusta
        spark = SparkSession.builder \
            .appName("TestConnection") \
            .master("local[*]")  # ✅ Usar modo local primero para test
            .config("spark.driver.memory", "512m") \
            .getOrCreate()

        print("✅ SparkSession local creada!")
        
        # Test simple
        df = spark.createDataFrame([(1, "test"), (2, "test2")], ["id", "name"])
        print(f"✅ DataFrame creado: {df.count()} filas")
        df.show()
        
        spark.stop()
        return True
        
    except Exception as e:
        print(f"❌ Error en test: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    test_spark()
