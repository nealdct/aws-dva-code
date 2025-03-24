## 1 - Create IAM policy for Lambda execution role

Create a policy named lambda-apigateway-policy

Use the following JSON:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1428341300017",
      "Action": [
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:Query",
        "dynamodb:Scan",
        "dynamodb:UpdateItem"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Sid": "",
      "Resource": "*",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow"
    }
  ]
}
```

## 2 - Create the execution role


Create a role named lambda-apigateway-role

Use case should be Lambda

Attach the lambda-apigateway-policy


## 3 - Create the Lambda function

Create a function named "LambdaFunctionOverHttps"

Use the latest Python runtime 

Use the lambda-apigateway-role as the execution role

Add the following code:

```python
import json
import boto3

dynamo = boto3.client('dynamodb')

def lambda_handler(event, context):

    operation = event.get('operation')

    # Ensure TableName is included in payload
    if 'tableName' in event:
        event['payload']['TableName'] = event['tableName']

    try:
        if operation == 'create':
            event['payload']['Item'] = format_item(event['payload']['Item'])
            dynamo.put_item(**event['payload'])
            key = {k: v for k, v in event['payload']['Item'].items() if 'id' in k.lower()}
            response = dynamo.get_item(TableName=event['payload']['TableName'], Key=key)
        elif operation == 'read':
            event['payload']['Key'] = format_item(event['payload']['Key'])
            response = dynamo.get_item(**event['payload'])
        elif operation == 'update':
            event['payload']['Key'] = format_item(event['payload']['Key'])
            event['payload']['AttributeUpdates'] = format_updates(event['payload']['AttributeUpdates'])
            response = dynamo.update_item(**event['payload'])
        elif operation == 'delete':
            event['payload']['Key'] = format_item(event['payload']['Key'])
            response = dynamo.delete_item(**event['payload'])
        elif operation == 'list':
            response = dynamo.scan(**event['payload'])
        elif operation == 'echo':
            response = "Success"
        elif operation == 'ping':
            response = "pong"
        else:
            raise ValueError(f"Unknown operation: {operation}")
        
        return {
            'statusCode': 200,
            'body': json.dumps(response)
        }
    except Exception as e:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': str(e)})
        }

def format_item(raw_item):

    formatted_item = {}
    for key, value in raw_item.items():
        if isinstance(value, str):
            formatted_item[key] = {"S": value}
        elif isinstance(value, int) or isinstance(value, float):
            formatted_item[key] = {"N": str(value)}
        elif isinstance(value, list):
            formatted_item[key] = {"L": [format_item(item) if isinstance(item, dict) else item for item in value]}
        elif isinstance(value, dict):
            formatted_item[key] = {"M": format_item(value)}
        else:
            raise ValueError(f"Unsupported type for key {key}: {type(value)}")
    return formatted_item

def format_updates(raw_updates):
    
    formatted_updates = {}
    for key, value in raw_updates.items():
        action = value.get("Action", "PUT")  # Default action is PUT
        formatted_value = format_item({key: value["Value"]})[key]
        formatted_updates[key] = {
            "Value": formatted_value,
            "Action": action
        }
    return formatted_updates
```


## 4 - Test the function

Use the following code to test the function:

```json
{
    "operation": "echo",
    "payload": {
        "somekey1": "somevalue1",
        "somekey2": "somevalue2"
    }
}
```

Optionally, save in a text file named input.txt and execute the following CLI command:

aws lambda invoke --function-name LambdaFunctionOverHttps --payload file://input.txt outputfile.txt

## 5 - Create REST API

Create a REST API named "DynamoDBOperations"

New API with a regional endpoint

## 6 - Create resource and method

Create a resource named dynamodbmanager

Create a POST method for the /dynamodbmanager resource

Use a Lambda integration (non proxy) and enter the function name as LambdaFunctionOverHttps

## 7 - Create a DynamoDB table

Create a table named lambda-apigateway

For the partition key use "id" (string)

## 8 - Test the configuration

In the REST API go to the /dynamodbmanager resource and choose the POST method

In the Method Execution pane, in the Client box, choose Test

In the Method Test pane, keep Query String and Headers empty, and for the request body enter the following JSON and choose "Test":

```json
{
  "operation": "create",
  "tableName": "lambda-apigateway",
  "payload": {
    "Item": {
      "id": "1234ABCDE",
      "number": 5
    }
  }
}
```

A 200 indicates a successful operation. Go to DynamoDB to check

You can also update an item:

```json
{
    "operation": "update",
    "tableName": "lambda-apigateway",
    "payload": {
        "Key": {
            "id": "1234ABCD"
        },
        "AttributeUpdates": {
            "number": {
                "Value": 999
            }
        }
    }
}
```
