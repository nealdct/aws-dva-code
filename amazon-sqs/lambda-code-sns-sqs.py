import json

def lambda_handler(event, context):
    for record in event.get("Records", []):
        try:
            body = record.get("body", "")
            print(f"Received message body: {body}")
        except Exception as e:
            print(f"Error processing record: {e}")
    
    return {"statusCode": 200, "body": "Processed successfully"}

