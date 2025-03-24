## Create payload

Create a file named "payload.json" with the following code:

{"key1": "value1", "key2": "value2"}

## Invoke function synchronously

aws lambda invoke --function-name mytestfunction --payload fileb://payload.json response.json

aws lambda invoke --function-name mytestfunction out

## Invoke function asynchronously

aws lambda invoke --function-name mytestfunction --invocation-type Event --payload fileb://payload.json response.json

