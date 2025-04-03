# React App Deployment with AWS CloudFormation

This document explains how to deploy the React application to AWS using CloudFormation.

## Deployment Options

This project provides two deployment options based on your AWS permissions:

### Option 1: Simple S3 Website (Limited Permissions)

If you have limited AWS permissions or are restricted by Service Control Policies (SCPs):

- **Architecture**: Uses only Amazon S3 for hosting
- **Deployment**: `./deploy-simple.sh`
- **Template**: `react-app-stack-simple.yaml`
- **Limitations**: No CDN, HTTPS requires additional setup

### Option 2: CloudFront + S3 (Full Permissions)

If you have full AWS permissions:

- **Architecture**: Uses Amazon S3 + CloudFront for global content delivery
- **Deployment**: `./deploy.sh`
- **Template**: `react-app-stack.yaml`
- **Benefits**: Global CDN, HTTPS, better performance

## Security Features

- Server-side encryption for S3 content
- Follows AWS security best practices
- Option 2 adds: CloudFront Origin Access Identity and HTTPS enforcement

## Deployment Process

1. CloudFormation creates the required infrastructure
2. React app is built locally
3. Build artifacts are uploaded to S3
4. Website is accessible via S3 URL (Option 1) or CloudFront URL (Option 2)

## Troubleshooting

If you encounter issues:

1. Ensure AWS CLI is properly configured with valid credentials
2. Check that you have sufficient permissions in your AWS account
3. If you see "Access denied" errors related to CloudFront, use the simple deployment option
4. For production deployments, request necessary permissions from your AWS administrator

## Customization

To customize the deployment:

1. Edit the CloudFormation template to modify infrastructure
2. Update the deployment script to change deployment parameters
3. For production use, consider adding custom domain names and proper security configurations
