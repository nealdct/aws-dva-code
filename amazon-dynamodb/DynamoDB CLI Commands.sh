# Import data
aws dynamodb batch-write-item --request-items file://mystore.json

#### SCANS ####

# Perform scan of ProductOrders table:
aws dynamodb scan --table-name mystore

# Use Page-Size Parameter:
aws dynamodb scan --table-name mystore --page-size 1
aws dynamodb scan --table-name mystore --page-size 2

# Use Max-Items Parameter:
aws dynamodb scan --table-name mystore --max-items 1

# Use Projection-Expression Parameter:
aws dynamodb scan --table-name mystore --projection-expression "created"
aws dynamodb scan --table-name mystore --projection-expression "category"
aws dynamodb scan --table-name mystore --projection-expression "colour"

# Use Filter-Expression Parameter:
aws dynamodb scan --table-name mystore --filter-expression "clientid = :username" --expression-attribute-values '{ ":username": { "S": "chris@example.com" }}'
aws dynamodb scan --table-name mystore --filter-expression "size = :n" --expression-attribute-values '{ ":n": { "N": "12" }}'
aws dynamodb scan --table-name mystore --filter-expression "size > :n" --expression-attribute-values '{ ":n": { "N": "12" }}'

#### QUERIES ####

# Use Key-Conditions Parameter:
aws dynamodb query  --table-name mystore --key-conditions '{ "clientid":{ "ComparisonOperator":"EQ", "AttributeValueList": [ {"S": "chris@example.com"} ] } }'

# Use Key-Condition-Expression Parameter:
aws dynamodb query --table-name mystore --key-condition-expression "clientid = :name" --expression-attribute-values '{":name":{"S":"chris@example.com"}}'