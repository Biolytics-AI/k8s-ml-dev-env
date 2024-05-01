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

## Kubernetes Configuration Setup

### Overview

For managing and interacting with your Kubernetes cluster, several configuration files are used to authenticate and establish secure communication. These files are stored securely and referenced via environment variables to simplify operations across different environments and tools.

### Configuration Files

Here is a breakdown of the key configuration files and their purpose:

- **Kubeconfig (`biolytics-kubeconfig.yaml`)**: This file contains the configuration data that `kubectl` and other Kubernetes tooling use to connect and authenticate with your Kubernetes cluster.
  
- **User Key (`biolytics-ai.key`)**: A private key file used in the SSL/TLS authentication process for securely interacting with the Kubernetes API.
  
- **User Certificate (`biolytics-ai.crt`)**: A certificate file that, paired with the user key, verifies the user's identity to the Kubernetes API.
  
- **CA Certificate (`ca.crt`)**: The Certificate Authority (CA) certificate, which is used to validate the certificates presented by the Kubernetes API server during SSL/TLS handshakes.

### Environment Variables Setup

To ensure that these files are referenced consistently and securely across scripts and Kubernetes tooling, we set up environment variables pointing to their paths. These variables should be defined in a `.env` file that is sourced at the beginning of your sessions or scripts.

### .env File Contents

Create a `.env` file in your project's root directory (or another appropriate location) and add the following environment variables:

```plaintext
KUBECONFIG=~/.kube/biolytics-dev/biolytics-kubeconfig.yaml
K8S_USER_KEY=~/.kube/biolytics-dev/biolytics-ai.key
K8S_USER_CERT=~/.kube/biolytics-dev/biolytics-ai.crt
K8S_CA_CERT=~/.kube/biolytics-dev/ca.crt
```

This setup will ensure that your Kubernetes command-line tools and scripts can automatically find and use the correct configuration files without needing to specify these paths repeatedly.

### Sourcing the .env File

To use the environment variables defined in the `.env` file, you need to source it in your terminal session or include it in your startup script (`~/.bashrc` or `~/.zshrc`):

```bash
source /path/to/your/.env
```

Adding this line to your shell's configuration file will automatically set these environment variables every time a new shell session is started.

### Security Note

Ensure that the `.env` file and the configuration files it references are kept secure and are not exposed publicly. Adjust file permissions to limit access to your user only:

```bash
chmod 600 ~/.kube/biolytics-dev/*
chmod 600 /path/to/your/.env
```

This configuration ensures that sensitive credentials and configurations used to access your Kubernetes cluster are managed securely and efficiently, aligning with best practices for DevOps and cloud infrastructure management.

## todo: Persistent Storage (Optional)

For a more persistent setup, consider adding a Persistent Volume Claim (PVC) to your deployment to retain your workspace data across container restarts.

# todo

 Configure gitlab-ci.yml to automate Docker builds and push to the Harbor registry.
 Create and apply Kubernetes configuration files (dev-environment-deployment.yaml, dev-environment-service.yaml, dev-environment-pvc.yaml).
 Document the process and configurations in readme.md to guide developers on how to connect and use the environment.
 Ensure all Kubernetes configurations and Dockerfiles are committed and reviewed via a pull request.
 Set up a Git strategy (submodules or scripts) that allows pushing code updates to both GitLab (using VPN) and GitHub to ensure that both repositories stay synchronized.
