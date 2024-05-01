# defines the remote development environment in a k8s cluster

## deploy the development environment

```bash
kubectl apply -f dev-environment-deployment.yaml
```

## Access the development environment

```bash
kubectl port-forward service/dev-environment 8080:8080
```

## How to acces the development environment from local vscode

1. Install the Remote Development extension in vscode
2. Add ssh key to the k8s cluster
3. add ssh key to vscode ssh config
4. connect to the remote development environment by clicking on connect to remote host
