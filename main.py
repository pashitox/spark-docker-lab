from jobs.batch_job import process_batch_data

if __name__ == "__main__":
    print("🚀 Iniciando aplicación...")
    success = process_batch_data()
    if success:
        print("✅ Job completado")
    else:
        print("❌ Job falló")
