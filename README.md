# aws-web-app
React-Nginx Web Application deployed on AWS ECS using Terraform as an example

This is a basic example to demonstrate...

(a) deploy simple infrastructure using Terraform and AWS cloud provider, consisting of...

Virtual Private Cloud (VPC) with 3 public subnets in 3 availability zones
Elastic Container Service (ECS)
Application Load Balancer (ALB)

(b) run a simple website on the infrastructure (a react-nginx sample application) by deploying an image to AWS ECR repository and running this in a task. The sample repo forked is here:
https://github.com/alwoods147/awesome-compose/tree/master/react-nginx


## React-Nginx Website Image Creation

- git clone git@github.com:alwoods147/awesome-compose.git
- cd react-nginx
- docker-compose build
- docker-compose up -d (the image can be seen on localhost)
- tag the image as latest
- push to AWS ECR repository by following the command instructions in the ECR repo

## React-Nginx Website Changes

- minor changes can be made to the homepage by editing the file in src/App.js
- rebuild the image with docker-compose build
- tag the image as latest
- push the new image to AWS ECR repository by following the command instructions in the ECR repo
- in ECS service on AWS, navigate to the running service and select 'Update Service'

## Infrastructure Creation

git clone git@github.com:alwoods147/aws-web-app.git
- terraform init
- terraform plan
- terraform apply
(resource provision and configuration can take several minutes here)

## Infrastructure Deletion
- Terminate instances
- Run terraform destroy

## Application Description
Cluster is created using EC2 container instances.

the verified module vpc is imported from the Terraform Registry, with other resources being created in their relevant files.

In file ecs.tf the following is created:

- A cluster of container instances (web-cluster)
- A capacity provider - an AWS Autoscaling group for EC2 instances. Here managed scaling is enabled, Amazon ECS manages the scale-in and scale-out actions of the Auto Scaling group used when creating the capacity provider. Target capacity is set to 85%, which will result in the Amazon EC2 instances in the Auto Scaling group being utilized for 85% and any instances not running any tasks will be scaled in.
- task definition with family web-family, volume and container definition is defined in the file container-def.json
- service web-service, desired count is set to 10, which means there are 10 tasks will be running simultaneously on the cluster. An ALB (Application load balancer) is attached to this service, so the traffic can be distributed between these tasks. The binpack task placement strategy is used, which places tasks on available instances that have the least available amount of the cpu (specified with the field parameter).

In file asg.tf the following is created:

- The launch configuration
- key pair (uses a variable set during terraform apply)
- security groups for the EC2 instances
- An ASG (auto-scaling group)

In file iam.tf roles are created, in order to associate EC2 instances to clusters, and other tasks.

In file alb.tf the ALB (Application Load Balancer) is created with target groups, security group and a listener.

