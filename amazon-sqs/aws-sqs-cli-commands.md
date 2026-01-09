## AWS SQS CLI Commands

aws sqs list-queues

aws sqs send-message --queue-url QUEUE-URL --message-body test-message-1 --delay-seconds 10

aws sqs receive-message --queue-url QUEUE-URL --wait-time-seconds 10

aws sqs send-message --queue-url QUEUE-URL --message-body test-long-short-polling