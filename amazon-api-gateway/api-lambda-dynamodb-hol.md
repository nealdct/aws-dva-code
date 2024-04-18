## 1 - Create IAM policy for Lambda execution role

Create a policy named lambda-apigateway-policy

Use the following JSON:

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

## 2 - Create the execution role


Create a role named lambda-apigateway-role

Use case should be Lambda

Attach the lambda-apigateway-policy


## 3 - Create the Lambda function (node.js 16x)

Create a function named LambdaFunctionOverHttps

Use node.js 16.x

Use the lambda-apigateway-role as the execution role

Add the following code:

console.log('Loading function');

var AWS = require('aws-sdk');
var dynamo = new AWS.DynamoDB.DocumentClient();

/**
 * Provide an event that contains the following keys:
 *
 *   - operation: one of the operations in the switch statement below
 *   - tableName: required for operations that interact with DynamoDB
 *   - payload: a parameter to pass to the operation being performed
 */
exports.handler = function(event, context, callback) {
    //console.log('Received event:', JSON.stringify(event, null, 2));

    var operation = event.operation;

    if (event.tableName) {
        event.payload.TableName = event.tableName;
    }

    switch (operation) {
        case 'create':
            dynamo.put(event.payload, callback);
            break;
        case 'read':
            dynamo.get(event.payload, callback);
            break;
        case 'update':
            dynamo.update(event.payload, callback);
            break;
        case 'delete':
            dynamo.delete(event.payload, callback);
            break;
        case 'list':
            dynamo.scan(event.payload, callback);
            break;
        case 'echo':
            callback(null, "Success");
            break;
        case 'ping':
            callback(null, "pong");
            break;
        default:
            callback(`Unknown operation: ${operation}`);
    }
};

## 4 - Test the function

Use the following code to test the function:

{
    "operation": "echo",
    "payload": {
        "somekey1": "somevalue1",
        "somekey2": "somevalue2"
    }
}

Optionally, save in a text file named input.txt and execute the following CLI command:

aws lambda invoke --function-name LambdaFunctionOverHttps --payload file://input.txt outputfile.txt

## 5 - Create REST API

Create a REST API named DynamoDBOperations

New API with a regional endpoint

## 6 - Create resource and method

Create a resource named DynamoDBManager

Create a POST method for the /dynamodbmanager resource

Use a Lambda integration (non proxy) and enter the function name as LambdaFunctionOverHttps

## 7 - Create a DynamoDB table

Create a table named lambda-apigateway

For the partition key use "id" (string)

## 8 - Test the configuration

In the REST API go to the /dynamodbmanager resource and choose the POST method

In the Method Execution pane, in the Client box, choose Test

In the Method Test pane, keep Query String and Headers empty, and for the request body enter the following JSON and choose "Test":

{
  "operation": "create",
  "tableName": "lambda-apigateway",
  "payload": {
    "Item": {
      "id": "1234ABCD",
      "number": 5
    }
  }
}

A 200 indicates a successful operation. Go to DynamoDB to check

You can also update an item:

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
