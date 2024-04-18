## Create Lambda function from zip file

zip function.zip index.js

aws lambda create-function --function-name EventSourceSQS --zip-file fileb://function.zip --handler index.handler --runtime nodejs16.x --role arn:aws:iam::821711655051:role/my-sqs-role

## Create event-source mapping

aws lambda create-event-source-mapping --function-name EventSourceSQS --batch-size 10 --event-source-arn arn:aws:sqs:us-east-1:821711655051:MyQueue

aws lambda list-event-source-mappings --function-name EventSourceSQS --event-source-arn arn:aws:sqs:us-east-1:821711655051:MyQueue

aws lambda delete-event-source-mapping --uuid 3b439c3f-22d9-4d2b-9395-c25df2cf049d
