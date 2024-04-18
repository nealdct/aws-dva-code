## AWS Step Functions State Machine with Lambda

## Step 1 - Create a Lambda Function

Create a Lambda function:
Name = HelloFunction
Runtime = Node.js 12.x
Role = Create a new role with basic Lambda permissions
Note the function ARN: *FUNCTION-ARN*
Add the following code and save/deploy:

exports.handler = (event, context, callback) => {
    callback(null, "Hello, " + event.who + "!");
};

Configure a test event with the following data:

{
    "who": "AWS Step Functions"
}

## Step 2 - Create a State Machine

Create a state machine
Choose to write workflow in code
Choose the standard type
Under Definition add the following code (update function ARN):
{
  "Comment": "A Hello World example of the Amazon States Language using an AWS Lambda function",
  "StartAt": "HelloWorld",
  "States": {
    "HelloWorld": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:123456789012:function:HelloFunction",
      "End": true
    }
  }
}

Choose next and create a new IAM role
Complete the wizard to create the state machine
Choose start execution and enter the following code (update your name):

{
    "who" : "YOUR NAME"
}

View the results in the execution output