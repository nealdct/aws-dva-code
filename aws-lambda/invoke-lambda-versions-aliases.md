## Invoke Lambda versions

aws lambda invoke --function-name myversiontest response.json
aws lambda invoke --function-name myversiontest:\$LATEST response.json

aws lambda invoke --function-name myversiontest:1 response.json

## Invoke Lambda alias

aws lambda invoke --function-name myversiontest:myapp response.json
