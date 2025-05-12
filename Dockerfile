# Use official Python image
FROM python:3.11-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    JUPYTER_ALLOW_INSECURE_WRITES=true

# Install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    ca-certificates \
    vim \
    less \
    net-tools \
    iputils-ping \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install JupyterLab
RUN pip install --upgrade pip && \
    pip install jupyterlab

# Set working directory
WORKDIR /workspace

# Expose port
EXPOSE 8888

# Run JupyterLab as root, with no token or password
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]
