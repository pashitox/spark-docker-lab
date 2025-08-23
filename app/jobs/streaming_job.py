from pyspark.sql import SparkSession
from pyspark.sql.functions import from_json, col, from_unixtime
from pyspark.sql.types import StructType, StructField, IntegerType, DoubleType

print("Initializing Spark Session...")

# Configuración con packages - approach más confiable
spark = SparkSession.builder \
    .appName("KafkaSparkStreaming") \
    .master("spark://spark-master:7077") \
    .config("spark.jars.packages", "org.apache.spark:spark-sql-kafka-0-10_2.12:3.4.1") \
    .config("spark.sql.adaptive.enabled", "false") \
    .getOrCreate()

print("Spark Session created successfully")

# Esquema para los datos JSON
schema = StructType([
    StructField("sensor_id", IntegerType()),
    StructField("temperature", DoubleType()),
    StructField("timestamp", DoubleType())
])

print("Starting Kafka stream reading...")

try:
    # Leer stream de Kafka
    df = spark.readStream \
        .format("kafka") \
        .option("kafka.bootstrap.servers", "kafka:9092") \
        .option("subscribe", "sensor_topic") \
        .option("startingOffsets", "latest") \
        .load()

    print("Kafka stream connected")

    # Procesar los datos
    processed_df = df.selectExpr("CAST(value AS STRING) as json_value") \
        .select(from_json(col("json_value"), schema).alias("data")) \
        .select("data.*")

    # Mostrar el schema para debugging
    processed_df.printSchema()

    # Agregaciones simples por sensor_id
    from pyspark.sql.functions import avg

    agg_df = processed_df.groupBy("sensor_id").agg(avg("temperature").alias("avg_temperature"))

    # Mostrar resultados en consola
    query = agg_df.writeStream \
        .outputMode("complete") \
        .format("console") \
        .option("truncate", "false") \
        .start()

    print("Streaming query started successfully!")
    print("Waiting for messages from Kafka...")

    query.awaitTermination()

except Exception as e:
    print(f"Error occurred: {e}")
    import traceback
    traceback.print_exc()