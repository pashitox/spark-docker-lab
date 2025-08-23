def get_spark_session(app_name="SparkApp"):
    from pyspark.sql import SparkSession
    
    return SparkSession.builder \
        .appName(app_name) \
        .master("spark://spark-master:7077") \
        .config("spark.submit.deployMode", "client") \
        .config("spark.driver.host", "spark-jupyter") \
        .config("spark.sql.adaptive.enabled", "true") \
        .getOrCreate()

def read_csv_with_schema(spark, path, schema=None):
    """Lee archivos CSV con manejo de errores"""
    return spark.read \
        .option("header", "true") \
        .option("inferSchema", "true" if not schema else "false") \
        .schema(schema if schema else None) \
        .csv(path)