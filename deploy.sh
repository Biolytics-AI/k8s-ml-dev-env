#!/bin/bash

# Set variables
REGISTRY_URL="ghcr.io/biolytics-ai/k8s-dev-env"  # Change this to your Docker registry URL
IMAGE_NAME="vscode-bastion-devcontainer"
IMAGE_TAG="latest"  # or use $(git rev-parse --short HEAD) for git commit hash based tags
NAMESPACE="biolyticsai-dev"

# Path to directories containing Kubernetes configs
K8S_CONFIG_PATH="."  # Path where Kubernetes YAML files are located

# Replace image name in the Kubernetes deployment file with the newly built image
echo "Updating Kubernetes deployment with new image..."
sed -i "s|your-registry/your-image-name:tag|$REGISTRY_URL/$IMAGE_NAME:$IMAGE_TAG|g" $K8S_CONFIG_PATH/dev-environment-deployment.yaml

# Apply Persistent Volume Claim (if needed)
# echo "Applying Persistent Volume Claim..."
# kubectl apply -f $K8S_CONFIG_PATH/dev-environment-pvc.yaml

# Apply Kubernetes deployment
echo "Deploying to Kubernetes..."
kubectl apply -f $K8S_CONFIG_PATH/dev-environment-deployment.yaml

# Apply Kubernetes service
echo "Applying Kubernetes service..."
kubectl apply -f $K8S_CONFIG_PATH/dev-environment-service.yaml

echo "Deployment completed successfully!"
