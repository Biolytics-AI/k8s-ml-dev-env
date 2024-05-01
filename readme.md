# Remote Development Environment in a Kubernetes Cluster

This guide outlines the steps to deploy and access a containerized development environment hosted in a Kubernetes cluster. The environment includes a development server accessible via VSCode, allowing for an integrated development experience directly from your local machine.

## Prerequisites

- **Kubernetes CLI**: Ensure that `kubectl` is installed and configured to communicate with your Kubernetes cluster.
- **VSCode**: Install Visual Studio Code on your local machine.
- **Remote Development Extension**: Install the Remote - SSH extension in VSCode, which is required to connect to the remote server.
- **SSH Keys**: You must have an SSH key generated and available on your local machine.

## Deploy the Development Environment

Deploy the containerized development environment to your Kubernetes cluster using a provided script that automates the application of Kubernetes resources and handling of SSH keys.

```bash
./deploy.sh
```

This script performs the following actions:

- Builds and pushes the Docker image to your registry.
- Applies the Kubernetes configurations, including deployments and services.
- Configures SSH settings for secure access.

## Access the Development Environment

### Port Forwarding

To access the development server running within the Kubernetes cluster, use `kubectl` to forward a local port to the remote service:

```bash
kubectl port-forward service/dev-environment 8080:8080
```

This command forwards port 8080 from your local machine to port 8080 on the service named `dev-environment`. The development environment can now be accessed via `localhost:8080`.

## Connect to the Remote Development Environment from Local VSCode

To connect VSCode to your remote development environment:

1. **Add SSH Key to the Kubernetes Cluster**:
   - Ensure your public SSH key is added to the authorized keys on any nodes or pods within the cluster that require SSH access. This is typically handled during the deployment process or manually added to the `.ssh/authorized_keys` of the relevant user in your container.

2. **Configure SSH in VSCode**:
   - Open the SSH configuration file in VSCode (typically located at `~/.ssh/config`) and add the following entry:

     ```bash
     Host k8s-dev
       HostName <external-ip-or-dns-name-of-k8s-node>
       User <your-username>
       IdentityFile ~/.ssh/id_rsa
       Port 22
     ```

     Replace `<external-ip-or-dns-name-of-k8s-node>`, `<your-username>`, and the path to your identity file as necessary.

3. **Connect to the Remote Host**:
   - Open VSCode, then navigate to the Remote Explorer sidebar.
   - Find the configured SSH target (`k8s-dev`) and click on "Connect".
   - Once connected, you can open the terminal within VSCode to interact with your Kubernetes development environment or open files and folders located on the remote server.

## todo: Persistent Storage (Optional)

For a more persistent setup, consider adding a Persistent Volume Claim (PVC) to your deployment to retain your workspace data across container restarts.
