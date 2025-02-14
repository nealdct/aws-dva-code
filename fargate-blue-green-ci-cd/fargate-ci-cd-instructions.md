## Part 1 - [HOL] Create Image and Push to ECR Repository

### Using EC2

1. Launch EC2 instance - Amazon Linux AMI, t2.micro
2. Connect to instance using EC2 Instance Connect
3. Attach an IAM role to EC2 and use policy "ecr-allow-all.json"
4. Run the following commands on EC2:

```bash
sudo su
yum update
yum install docker
systemctl enable docker.service
systemctl start docker.service
docker pull nginx
docker images (to view the images)
```

### Using AWS CloudShell

1. Typically Docker is installed in CloudShell so we only need to run the following command:

```bash
docker pull nginx
```

### Create Repo, tag, and push image

```bash
aws ecr create-repository --repository-name nginx --region us-east-1
docker tag nginx:latest <ACCOUNT-ID>.dkr.ecr.us-east-1.amazonaws.com/nginx:latest
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ACCOUNT-ID>.dkr.ecr.us-east-1.amazonaws.com/nginx
docker push <ACCOUNT-ID>.dkr.ecr.us-east-1.amazonaws.com/nginx:latest
```

## Part 2 - [HOL] Create Task Definition and ALB

1. Update the account ID in the role ARN within the `taskdef.json` file
2. From a CLI with ECS permissions, change to a directory with the `taskdef.json` file and run the following command:

```bash
aws ecs register-task-definition --cli-input-json file://taskdef.json
```

3. Create an Application Load Balancer
- Should be internet facing
- Listen on HTTP port 80
- Add a second listener on HTTP 8080
- Choose 2 public subnets in different AZs
- Create a new TG - target-group-1, protocol HTTP 80, target type = IP address
- Create a second TG - target-group-2, protocol HTTP 8080, target type = IP address
- For the second listener, forward to target-group-2

4. Update security group to allow inbound on 80 and 8080

## Part 3 - [HOL] Create Fargate Cluster and Service

1. Create a Fargate cluster named "ecs-cluster"
2. Update the placeholders in the `create-service.json` file
3. From a CLI with ECS permissions, change to the directory with the `create-service.json` file and run the following commands:

```bash
aws ecs create-service --service-name my-service --cli-input-json file://create-service.json
aws ecs describe-services --cluster ecs-cluster --services my-service
```

## Part 4 - [HOL] ECS Lab - CodeDeploy Application and Pipeline

***You will need a personal GitHub account for these exercises***

### Create GitHub Repo and Commit files

1. Create a GitHub repository called "ecs-lab"
2. Clone the repository
3. Edit the taskdef.json file and change the image name to "<IMAGE1_NAME>" then save and copy into repository folder
4. Also copy the `appspec.yaml` file into the repository
5. Commit files and push to GitHub using the following commands:

```bash
git add -A
git commit -m "first commit"
git push
```

### Create CodeDeploy Application

1. Create an IAM role for CodeDeploy
2. Use case should be CodeDeploy - ECS
3. Add the policy AWSCodeDeployRoleForECS
4. Enter the name as CodeDeployECSRole

5. Create an application in CodeDeploy named ecs-lab
6. Choose ECS as the compute platform
7. Create a deployment group named codedeploy-ecs
8. Select the service role, cluster, and service
9. Select the ALB and associated settings

### Connect your GitHub Repo to CodePipeline

1. In the Developer Tools console, go to Settings > Connections
2. Click "Create connection"
3. Select "GitHub"
4. Provide a connection name
5. Click "Connect to GitHub"
6. Authenticate to your personal GitHub account

### Create a Pipeline

1. Create a pipeline in CodePipeline named MyImagePipeline
2. Allow CodePipeline to create a new IAM role
3. For source provider select "GitHub (via GitHub App")
4. Select the connection and enter the repo name and main branch
5. Skip the build stage and test stage
6. Choose ECS (Blue/Green) for the deploy provider
7. Select the app name and deployment group
8. For ECS task definition specify the SourceArtifact as taskdef.json
9. For CodeDeploy AppSpec file specify the SourceArtifact as appspec.yaml
10. Create the Pipeline

### Edit the source stage
1. Edit the pipeline and source stage
2. Click "Add action"
3. Enter "Image" as the action name
4. Choose "Amazon ECR" as the action provider
5. Enter the repo name (nginx)
6. Set output artifacts to "MyImage"
7. Save the changes

### Edit the deploy stage

1. Edit the pipeline again and the deploy stage and action
2. Under input artifacts specify MyImage (in addition to SourceArtifact)
3. Under "Dynamically udpate task definition image" select MyImage
4. For the placeholder text in the task definition enter "IMAGE1_NAME"
4. Save the Pipeline
5. Release change

## Part 5 - Implement Blue/Green Update to ECS

To cause a blue/green deployment you can make a change to the source image and push the image or delete the image from ECR and then push the image to the repository again

The pipeline should execute and a replacement task set should be created
To rerun, you can terminate steps 4/5 by clicking "Stop and roll back deployment"



