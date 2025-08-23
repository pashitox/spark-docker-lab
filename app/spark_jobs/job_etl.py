from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("ETLJob") \
    .master("spark://spark-master:7077") \
    .getOrCreate()

df = spark.read.csv("/data/input/sample_users.csv", header=True, inferSchema=True)
df_clean = df.filter(df.age > 28)
df_clean.write.mode("overwrite").parquet("/data/output/users_over_28")

spark.stop()

