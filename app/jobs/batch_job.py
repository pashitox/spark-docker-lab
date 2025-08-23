from pyspark.sql import SparkSession

def process_batch_data():
    try:
        spark = SparkSession.builder \
            .appName("BatchProcessing") \
            .master("spark://spark-master:7077") \
            .getOrCreate()

        print("✅ SparkSession conectada al clúster")

        # Leer CSV
        df = spark.read.csv("/data/batch/clientes.csv", header=True, inferSchema=True)
        print(f"📊 Filas leídas: {df.count()}")

        df.show(5)

        spark.stop()
        return True

    except Exception as e:
        print(f"❌ Error en el job: {e}")
        return False



