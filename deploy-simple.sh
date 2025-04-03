#!/bin/bash

# Set variables
STACK_NAME="react-app-stack-simple"
REGION="eu-west-1"  # Change this to your preferred region

echo "Step 1: Deploying CloudFormation stack (S3 only)..."
aws cloudformation deploy \
  --stack-name $STACK_NAME \
  --template-file react-app-stack-simple.yaml \
  --capabilities CAPABILITY_IAM \
  --region $REGION

if [ $? -ne 0 ]; then
  echo "Failed to deploy CloudFormation stack"
  exit 1
fi

echo "Step 2: Building the React app..."
npm run build

if [ $? -ne 0 ]; then
  echo "Failed to build React app"
  exit 1
fi

echo "Step 3: Getting the S3 bucket name from CloudFormation outputs..."
BUCKET_NAME=$(aws cloudformation describe-stacks \
  --stack-name $STACK_NAME \
  --query "Stacks[0].Outputs[?OutputKey=='S3BucketName'].OutputValue" \
  --output text \
  --region $REGION)

echo "Step 4: Uploading build files to S3 bucket: $BUCKET_NAME..."
aws s3 sync build/ s3://$BUCKET_NAME/ --delete --region $REGION

if [ $? -ne 0 ]; then
  echo "Failed to upload files to S3"
  exit 1
fi

echo "Step 5: Getting the S3 website URL..."
WEBSITE_URL=$(aws cloudformation describe-stacks \
  --stack-name $STACK_NAME \
  --query "Stacks[0].Outputs[?OutputKey=='WebsiteURL'].OutputValue" \
  --output text \
  --region $REGION)

echo "Deployment completed successfully!"
echo "Your application is now available at: $WEBSITE_URL"
echo "Note: This is a simple S3 website deployment without CloudFront. For production use, consider requesting CloudFront permissions from your AWS administrator."
