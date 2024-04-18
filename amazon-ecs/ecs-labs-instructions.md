## Part 1 - [HOL] Create Image and Push to ECR Repository

Launch EC2 instance - Amazon Linux 2 AMI, t2.micro
Connect to instance using EC2 Instance Connect

Run the following commands on EC2:

sudo su
yum update
yum install docker
systemctl enable docker.service
systemctl start docker.service
docker pull nginx
docker images

Create an IAM role and use policy "ecr-allow-all.json"
Attach role to EC2 instance and then run the following commands (replace account number):

aws ecr create-repository --repository-name nginx --region us-east-1
docker tag nginx:latest 821711655051.dkr.ecr.us-east-1.amazonaws.com/nginx:latest
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 821711655051.dkr.ecr.us-east-1.amazonaws.com/nginx
docker push 821711655051.dkr.ecr.us-east-1.amazonaws.com/nginx:latest

## Part 2 - [HOL] Create Task Definition and ALB

From a CLI with ECS permissions, change to the directory with the taskdef.json file and run the following commands:

aws ecs register-task-definition --cli-input-json file://taskdef.json

Create an Application Load Balancer
Should be internet facing
Listen on HTTP port 80
Add a second listener on HTTP 8080
Choose 2 public subnets in different AZs
Create a new TG - target-group-1, protocol HTTP 80, target type = IP address
Creat a second TG - target-group-2, protocol HTTP 8080, target type = IP address
For the second listener, forward to target-group-2

Update security group to allow inbound on 80 and 8080

## Part 3 - [HOL] Create Fargate Cluster and Service

Create a Fargate cluster named "ecs-cluster"
From a CLI with ECS permissions, change to the directory with the create-service.json file and run the following commands:

aws ecs create-service --service-name my-service --cli-input-json file://create-service.json
aws ecs describe-services --cluster ecs-cluster --services my-service


## Part 4 - [HOL] ECS Lab - CodeDeploy Application and Pipeline

Create a CodeCommit repository called "ecs-lab"
Clone the repository
Edit the taskdef.json file and change the image name to "<IMAGE1_NAME>" then save and copy into repository folder
Also copy the appspec.yaml file into the repository

Commit files and push to CodeCommit using the following commands:

git add -A
git commit -m "first commit"
git push

Create an IAM role for CodeDeploy
Use case should be CodeDeploy - ECS
Add the policy AWSCodeDeployRoleForECS
Enter the name as CodeDeployECSRole

Create an application in CodeDeploy named ecs-lab
Choose ECS as the compute platform
Create a deployment group named codedeploy-ecs
Select the cluster and service

Create a pipeline in CodePipeline named MyImagePipeline
Allow CodePipeline to create a new IAM role
Select the CodeCommit source repository and branch
Skip the build stage
Choose ECS (Blue/Green) for the deploy provider
Choose app name and deployment group
Choose the SourceArtifact as taskdef.json
And appspec.yaml
Create the Pipeline

Add an ECR source action
Edit the pipeline and source stage
Add a parallel action
Add the action name Image
Action provider is Amazon ECR
Repository is nginx
Output artifacts is MyImage

Next, edit the deploy action
Add the input artifact (MyImage)
Under, dynamically update task definition image, select MyImage and then enter IMAGE1_NAME in the placeholder text

## Part 5 - Implement Blue/Green Update to ECS

To cause a blue/green deployment, either:

1) Make a change to the source image and push the image
2) Delete the image from ECR and then push the image to the repository

The pipeline should execute and a replacement task set should be created
To rerun, you can terminate steps 4/5 by clicking "Stop and roll back deployment"




