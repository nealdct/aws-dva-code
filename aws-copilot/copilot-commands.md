# Deploy demo app using AWS Copilot

1. Launch an EC2 instance
aws ec2 run-instances --image-id ami-0dfcb1ef8550277af --instance-type t2.micro
2. Using EC2 Instance Connect, install Docker on the instance
sudo yum install docker
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo usermod -a -G docker ec2-user
id ec2-user
newgrp docker
3. Install git
sudo yum install git
4. Install the Copilot CLI
sudo curl -Lo /usr/local/bin/copilot https://github.com/aws/copilot-cli/releases/latest/download/copilot-linux && sudo chmod +x /usr/local/bin/copilot && copilot --help
5. Clone the Copilot repository and change into the demo-app directory
git clone https://github.com/aws-samples/amazon-ecs-cli-sample-app.git demo-app
cd demo-app
6. Run the init command to start the build
copilot init --app demo --name api --type 'Load Balanced Web Service' --dockerfile './Dockerfile' --port 80 --deploy
7. Delete the app by running the following command
copilot app delete