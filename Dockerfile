FROM alpine:3.18

LABEL org.opencontainers.image.description="Docker image for refreshing AWS ECR credentials in Kubernetes cluster"

# Install required packages and dependencies
RUN apk update && apk add --update --no-cache \
    bash \
    curl \
    git \
    openssh \
    python3 \
    py3-pip \
    py3-setuptools \
    py3-wheel \
    jq \
    libffi-dev \
    musl-dev \
    gcc \
    libressl-dev

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# Upgrade pip and install AWS CLI
RUN pip3 install --upgrade pip && \
    pip3 install --upgrade awscli

# Set working directory and copy scripts
WORKDIR /scripts
COPY scripts/ /scripts

# Set entrypoint to the provided script
ENTRYPOINT ["bash", "/scripts/entrypoint.sh"]