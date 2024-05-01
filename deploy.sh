#!/bin/bash

# Set variables
REGISTRY_URL="your-registry-url"  # Change this to your Docker registry URL
IMAGE_NAME="dev-environment"
IMAGE_TAG="latest"  # or use $(git rev-parse --short HEAD) for git commit hash based tags
NAMESPACE="biolyticsai-dev"

# Path to directories containing Dockerfile and Kubernetes configs
DOCKERFILE_PATH="."  # Path where Dockerfile is located
K8S_CONFIG_PATH="."  # Path where Kubernetes YAML files are located

# Build Docker image
echo "Building Docker image..."
docker build -t $REGISTRY_URL/$IMAGE_NAME:$IMAGE_TAG $DOCKERFILE_PATH

# Push Docker image to registry
echo "Pushing Docker image to registry..."
docker push $REGISTRY_URL/$IMAGE_NAME:$IMAGE_TAG

# Replace image name in the Kubernetes deployment file with the newly built image
echo "Updating Kubernetes deployment with new image..."
sed -i "s|your-registry/your-image-name:tag|$REGISTRY_URL/$IMAGE_NAME:$IMAGE_TAG|g" $K8S_CONFIG_PATH/dev-environment-deployment.yaml

# # Apply Persistent Volume Claim
# echo "Applying Persistent Volume Claim..."
# kubectl apply -f $K8S_CONFIG_PATH/dev-environment-pvc.yaml

# Apply Kubernetes deployment
echo "Deploying to Kubernetes..."
kubectl apply -f $K8S_CONFIG_PATH/dev-environment-deployment.yaml

# Apply Kubernetes service
echo "Applying Kubernetes service..."
kubectl apply -f $K8S_CONFIG_PATH/dev-environment-service.yaml

echo "Deployment completed successfully!"
