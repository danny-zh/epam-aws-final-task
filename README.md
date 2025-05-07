# Gitea Infrastructure on AWS

This project deploys a highly available Gitea infrastructure on AWS using CloudFormation templates. The infrastructure is designed with scalability, reliability, and security in mind.

## Architecture Overview

The infrastructure consists of the following components:

- **Network Stack**: VPC, public and private subnets across multiple availability zones
- **Security Groups**: Properly configured security groups for each component
- **Application Load Balancer (ALB)**: Distributes traffic to the Gitea instances
- **RDS Database**: PostgreSQL database for Gitea
- **EFS File System**: Shared storage for Gitea data
- **Auto Scaling Group**: Maintains desired capacity of Gitea instances
- **CloudWatch Monitoring**: Monitors the infrastructure and triggers alarms when needed
- **IAM Roles**: Proper permissions for the infrastructure components

## CloudFormation Templates

The infrastructure is deployed using nested CloudFormation stacks:

- `main.yaml`: Main stack that orchestrates all other stacks
- `network-stack.yaml`: VPC, subnets, route tables, and internet gateway
- `security-groups.yaml`: Security groups for all components
- `alb.yaml`: Application Load Balancer configuration
- `rds.yaml`: RDS database for Gitea
- `efs.yaml`: EFS file system for shared storage
- `iam.yaml`: IAM roles and policies
- `launch-template.yaml`: EC2 launch template for Gitea instances
- `autoscaling.yaml`: Auto Scaling Group configuration
- `cloudwatch.yaml`: CloudWatch alarms and metrics

## Prerequisites

- AWS CLI installed and configured
- S3 bucket for storing CloudFormation templates
- IAM role with sufficient permissions to create the resources
- Environment variables set in `.env` file

## Environment Variables

Create a `.env` file with the following variables:

```
S3URI=s3://your-bucket-name
S3BUCKET=https://your-bucket-name.s3.amazonaws.com
BUCKET=your-bucket-name
STACKNAME=gitea-stack
MAINFILE=main.yaml
ROLEARN=arn:aws:iam::your-account-id:role/CloudFormationAdminRole
REGION=us-east-1
GITEAADMIN=your-gitea-admin-username
GITEAPASS=your-gitea-admin-password
ACCOUNTID=your-aws-account-id
```

## Deployment

To deploy the infrastructure:

```bash
# Deploy the entire stack
make deploy

# Upload CloudFormation templates to S3
make upload-files

# Update an existing stack
make update-stack

# Create a new stack
make create-stack
```

## Cleanup

To destroy the infrastructure:

```bash
make destroy
```

## Scripts

- `scripts/create_role.sh`: Creates the CloudFormation admin role
- `scripts/s3_upload.sh`: Uploads a specific file to S3

## Security Considerations

- All sensitive parameters are marked with `NoEcho: true`
- EFS is encrypted at rest
- RDS database is deployed in private subnets
- Security groups follow the principle of least privilege

## Monitoring and Scaling

- CloudWatch alarms are configured to monitor the infrastructure
- Auto Scaling Group ensures high availability and scalability
- Load balancer distributes traffic across multiple availability zones

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.