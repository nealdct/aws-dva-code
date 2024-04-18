## Invoke function synchronously

aws lambda invoke --function-name mytestfunction --payload BASE64-ENCODED-STRING response.json

aws lambda invoke --function-name mytestfunction out

## Invoke function asynchronously

aws lambda invoke --function-name mytestfunction --invocation-type Event --payload BASE64-ENCODED-STRING response.json

