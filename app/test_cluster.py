#!/usr/bin/env python3
import sys
sys.path.insert(0, '/opt/bitnami/spark/python')
sys.path.insert(0, '/opt/bitnami/spark/python/lib/py4j-0.10.9.7-src.zip')

def test_cluster():
    try:
        from pyspark.sql import SparkSession
        import time
        
        print("🧪 Probando conexión al cluster Spark...")
        
        # Dar tiempo al cluster para estabilizarse
        time.sleep(5)
        
        spark = SparkSession.builder \
            .appName("TestCluster") \
            .master("spark://spark-master:7077") \
            .config("spark.driver.host", "spark-worker-1") \
            .config("spark.driver.memory", "512m") \
            .config("spark.executor.memory", "512m") \
            .config("spark.network.timeout", "300s") \
            .getOrCreate()

        print("✅ SparkSession en cluster creada!")
        
        # Test simple
        df = spark.createDataFrame([(1, "cluster_test"), (2, "works!")], ["id", "message"])
        print(f"✅ DataFrame en cluster: {df.count()} filas")
        df.show()
        
        spark.stop()
        return True
        
    except Exception as e:
        print(f"❌ Error en cluster: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    test_cluster()
