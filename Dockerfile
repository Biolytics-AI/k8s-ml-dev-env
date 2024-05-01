ARG BASE_IMAGE=pytorch/pytorch:2.2.1-cuda12.1-cudnn8-runtime


FROM $BASE_IMAGE as base

# Install basics
RUN apt-get update && apt-get install -y curl git openssh-server sudo

# Install your development tools, languages, etc.

# Install code-server (VSCode)
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Setup a user
RUN adduser --disabled-password --gecos '' developer && \
    adduser developer sudo && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER developer
WORKDIR /home/developer
EXPOSE 8080

CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "none"]
