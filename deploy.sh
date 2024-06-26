#!/bin/bash

# Apply Persistent Volume Claim (if needed)
echo "Applying Persistent Volume Claim..."
kubectl apply -f dev-environment-pvc.yaml

# Apply Kubernetes deployment
echo "Deploying to Kubernetes..."
kubectl apply -f dev-environment-deployment.yaml

# Apply Kubernetes service
echo "Applying Kubernetes service..."
kubectl apply -f dev-environment-service.yaml

kubectl apply -f dev-environment-service-ingress.yaml

echo "Deployment completed successfully!"