#!/usr/bin/env python3
"""
Punto de entrada principal - Versión corregida
"""
import sys
import os
import time

# Configurar variables de entorno ANTES de importar pyspark
os.environ['IVY_HOME'] = '/tmp/.ivy2'
os.environ['_JAVA_OPTIONS'] = '-Divy.home=/tmp/.ivy2 -Duser.home=/tmp'

# Configurar path para pyspark y app
sys.path.insert(0, '/opt/bitnami/spark/python')
sys.path.insert(0, '/opt/bitnami/spark/python/lib/py4j-0.10.9.7-src.zip')
sys.path.insert(0, '/app')

print("🚀 Iniciando aplicación Spark...")

try:
    # Importar pyspark
    import pyspark
    print(f"✅ PySpark version: {pyspark.__version__}")
    
    # Importar nuestro código - SIN 'app.'
    from jobs.batch_job import process_batch_data
    print("✅ Módulos importados correctamente")
    
    # Ejecutar job batch
    success = process_batch_data()
    
    if success:
        print("✅ Procesamiento completado exitosamente!")
    else:
        print("❌ Procesamiento falló")
        
except Exception as e:
    print(f"❌ Error: {e}")
    import traceback
    traceback.print_exc()

print(f"Hora de finalización: {time.strftime('%Y-%m-%d %H:%M:%S')}")
