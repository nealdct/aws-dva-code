import json

def lambda_handler(event, context):
    name = "you"
    city = "World"
    time = "day"
    day = ""
    response_code = 200
    
    print("request:", json.dumps(event))
    
    query_params = event.get("queryStringParameters") or {}
    headers = event.get("headers") or {}
    body = json.loads(event.get("body", "{}")) if event.get("body") else {}
    
    if "name" in query_params:
        print("Received name:", query_params["name"])
        name = query_params["name"]
    
    if "city" in query_params:
        print("Received city:", query_params["city"])
        city = query_params["city"]
    
    if "day" in headers:
        print("Received day:", headers["day"])
        day = headers["day"]
    
    if "time" in body:
        time = body["time"]
    
    greeting = f"Good {time}, {name} of {city}."
    if day:
        greeting += f" Happy {day}!"
    
    response_body = {
        "message": greeting,
        "input": event
    }
    
    response = {
        "statusCode": response_code,
        "headers": {
            "x-custom-header": "my custom header value"
        },
        "body": json.dumps(response_body)
    }
    
    print("response:", json.dumps(response))
    return response