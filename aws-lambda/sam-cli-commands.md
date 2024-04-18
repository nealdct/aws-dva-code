
## Deploy Hello World application

sam init --runtime python3.7 --dependency-manager pip --app-template hello-world --name sam-app

cd sam-app

sam build

sam deploy --guided

curl API-ENDPOINT-URL

