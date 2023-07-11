# App Deployment using GCP

## Problem Statement

POC on Google Cloud Platform (GCP) to explore deploying and scaling Spring Boot applications that utilize a Cloud SQL database. The objective is to design and implement a solution that involves creating two identical instances running Spring Boot applications using instance group, connecting them to a Cloud SQL database, and utilizing the Google  Application Load Balancer for load balancing traffic between the instances. Additionally, it is required to modify the application code to include the metadata such as hostname, IP address, VPC, Zone etc. in the http response headers. This modification will provide clear visibility into which instance is being accessed when making GET requests to the load balancer.

## Services Used

1. VPC(Virtual Private Cloud)
2. Compute Engine - Instance Group, Instance template, Image
3. Cloud SQL
4. Google Application Load Balancer

## Provisioning infrastucture manually

1. Create custom VPC with 2 subnets
2. Create a private MySQL database instance on Cloud SQL, enable private service access.
3. Create custom image using Packer for Springboot application.
4. Create instance template using the instance image from previous step.
5. Create instance group using instance template from previous step with min 2 and max 3 instances for autoscaling, autoscaling will be  triggered based on configured CPU threshold, configure health check parameters for instance group.
6. Create Application Load Balancer using instance group created in previous step
7. Send a GET request using Postman and inspect the response headers to retrieve metadata about the instance that processed the request.
8. Send multiple request to the load balancer endpoint and monitor the auto scale up of instance on crossing CPU threshold limit configured in load balancer autoscaler and also monitor the auto scale down of instance after the CPU usage is below threshold.

## Provisioning infrastucture with terraform

### Prequisite

1. Running Cloud SQL instance as the ip of the instance is used in java application
2. A compute engine image created with packer which contains the Running Java Application

### Main Components to be created using Terraform

1. Network
   1. VPC
   2. Subnets
   3. Firewall Rule
2. Instance Group
   1. Instance Template
   2. Instance Group
   3. Autoscaler
   4. Health Check
3. Load Balancer
   1. Frontend
      1. Global IP address
      2. Forwarding Rule
   2. Backend
      1. http proxy
   3. load balancer
      1. url map
