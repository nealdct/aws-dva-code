## Create Lambda function and SQS queue

1. Create a Lambda function using the Python runtime
2. Add the following code:

```python
import json
import logging

# Configure logging to send logs to CloudWatch
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    """
    AWS Lambda function to process SQS messages.
    Logs each message body to CloudWatch.
    """
    try:
        # Check if 'Records' exist in the event
        if "Records" in event:
            for record in event["Records"]:
                body = record.get("body", "No body found")
                
                # Log the message body
                logger.info(f"Received message: {body}")

        else:
            logger.warning("No records found in the event.")

    except Exception as e:
        logger.error(f"Error processing SQS message: {str(e)}")

    return {"statusCode": 200, "body": "Messages processed"}
```

3. Add the "AWSLambdaSQSQueueExecutionRole" permissions policy to the function execution role
4. Create a standard SQS queue

## Create the event-source mapping

1. Run the following AWS CLI command to create the event source mapping:

aws lambda create-event-source-mapping --function-name EventSourceSQS --batch-size 10 --event-source-arn YOUR-SQS-QUEUE-ARN

2. Run the following AWS CLI command to list the event source mappings:

aws lambda list-event-source-mappings --function-name EventSourceSQS --event-source-arn YOUR-SQS-QUEUE-ARN

3. Send a test message manually in the SQS queue and check the output appears in CloudWatch Logs

4. Run the following AWS CLI command to delete the event source mapping:
aws lambda delete-event-source-mapping --uuid YOUR-ESM-UUID