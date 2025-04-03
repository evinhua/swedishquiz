#!/bin/bash

# Set variables
STACK_NAME="react-app-stack-https"
REGION="eu-west-1"  # CloudFront requires certificates in us-east-1

echo "Step 1: Deploying CloudFormation stack (S3 + minimal CloudFront for HTTPS)..."
aws cloudformation deploy \
  --stack-name $STACK_NAME \
  --template-file react-app-stack-https.yaml \
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

echo "Step 5: Getting the CloudFront URL..."
CLOUDFRONT_URL=$(aws cloudformation describe-stacks \
  --stack-name $STACK_NAME \
  --query "Stacks[0].Outputs[?OutputKey=='CloudFrontURL'].OutputValue" \
  --output text \
  --region $REGION)

echo "Deployment completed successfully!"
echo "Your application is now available at: $CLOUDFRONT_URL"
echo "Note: It may take a few minutes for the CloudFront distribution to fully deploy."
