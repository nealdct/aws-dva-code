## Function code

```python
import json
from datetime import datetime

def lambda_handler(event, context):
    event_received_at = datetime.utcnow().isoformat()
    print('Event received at:', event_received_at)
    print('Received event:', json.dumps(event, indent=2))

    success_flag = event.get('Success')

    if success_flag is True:
        print("Success")
        return {
            "statusCode": 200,
            "body": "Function succeeded"
        }
    else:
        print("Failure")
        raise Exception("Failure from event, Success = false, I am failing!")
```

## Generate success message

aws lambda invoke --function-name desttest --invocation-type Event --payload eyJTdWNjZXNzIjp0cnVlfQ== response.json

{"Success":true}

## Failure message

{"Success":false}

aws lambda invoke --function-name desttest --invocation-type Event --payload eyJTdWNjZXNzIjpmYWxzZX0= response.json

