```python
import json
import os

def lambda_handler(event, context):
    DB_HOST = os.environ["DB_HOST"]
    DB_USER = os.environ["DB_USER"]
    DB_PASS = os.environ["DB_PASS"]
    print("Connected to %s as %s with %s" % (DB_HOST, DB_USER, DB_PASS))
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
```

## Code for encrypted variables

```python
import json
import os
import boto3
from base64 import b64decode

def lambda_handler(event, context):
    DB_HOST = os.environ["DB_HOST"]
    DB_USER = os.environ["DB_USER"]
    DB_PASS = os.environ["DB_PASS"]
    ENCRYPTED = os.environ['DB_PASS']
    DECRYPTED = boto3.client('kms').decrypt(
    CiphertextBlob=b64decode(ENCRYPTED),
    EncryptionContext={'LambdaFunctionName': os.environ['AWS_LAMBDA_FUNCTION_NAME']}
)['Plaintext'].decode('utf-8')
    print("Connected to %s as %s with %s" % (DB_HOST, DB_USER, DB_PASS))
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
```










