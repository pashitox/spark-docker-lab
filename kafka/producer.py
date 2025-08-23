from kafka import KafkaProducer
import json, time, random

producer = KafkaProducer(
    bootstrap_servers='localhost:29092',  # Usa el puerto mapeado de Kafka
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

print("Producer started. Sending messages every 2 seconds...")
print("Press Ctrl+C to stop")

try:
    while True:
        msg = {
            "sensor_id": random.randint(1, 5),
            "temperature": round(random.uniform(20.0, 30.0), 2),
            "timestamp": time.time()
        }
        producer.send("sensor_topic", msg)
        print(f"Sent: {msg}")
        time.sleep(2)
except KeyboardInterrupt:
    print("\nProducer stopped.")
finally:
    producer.close()