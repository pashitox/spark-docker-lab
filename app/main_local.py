#!/usr/bin/env python3
"""
Versión local para desarrollo
"""
import sys
import os
import time

sys.path.insert(0, '/opt/bitnami/spark/python')
sys.path.insert(0, '/opt/bitnami/spark/python/lib/py4j-0.10.9.7-src.zip')
sys.path.insert(0, '/app')

print("🚀 Iniciando aplicación Spark en modo LOCAL...")

try:
    import pyspark
    print(f"✅ PySpark {pyspark.__version__}")
    
    from jobs.batch_job import process_batch_data
    print("✅ Módulos importados")
    
    success = process_batch_data()
    
    if success:
        print("✅ Procesamiento completado!")
    else:
        print("❌ Procesamiento falló")
        
except Exception as e:
    print(f"❌ Error: {e}")
    import traceback
    traceback.print_exc()

print(f"Hora de finalización: {time.strftime('%Y-%m-%d %H:%M:%S')}")
