# Using a PyTorch image with CUDA support as the base
ARG BASE_IMAGE=nvidia/cuda:12.5.0-runtime-ubuntu22.04
FROM $BASE_IMAGE as base

# Install necessary packages for building Python packages and managing dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    build-essential \
    libffi-dev \
    libssl-dev \
    gcc \
    curl \
    git \
    openssh-server \
    sudo \
    python3-pip \
    jq \ 
    gh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
# Install yq
RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && \
    chmod +x /usr/bin/yq
    
# Install Poetry for Python dependency management
RUN pip install --no-cache-dir poetry==1.8.2
# Set environment variables for Poetry
ENV POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache
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
