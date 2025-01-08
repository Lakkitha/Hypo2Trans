# Use newer base image with Python 3.9+
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Install Python and dependencies
RUN apt-get update && apt-get install -y \
    python3-pip python3-dev git && \
    rm -rf /var/lib/apt/lists/* && \
    python3.9 \
    python3.9-dev \
    pip3 install --upgrade pip

# Set working directory
WORKDIR /hypo2trans

# Copy requirements file
COPY requirements.txt /hypo2trans/requirements.txt
COPY generate_data/requirements.txt /hypo2trans/generate_data/requirements.txt
COPY generate_data/whisper/requirements.txt /hypo2trans/generate_data/whisper/requirements.txt

# Install certifi package
RUN pip3 install cffi certifi

# Install Python dependencies
RUN pip install -r requirements.txt && \
    pip install -r generate_data/requirements.txt && \
    pip install -r generate_data/whisper/requirements.txt

# Copy the entire project into the container
COPY . /hypo2trans

# Upgrade pip, setuptools, and wheel
RUN pip3 install --upgrade pip setuptools wheel

# Set the working directory to where finetune.py is located
WORKDIR /hypo2trans/H2T-LoRA

# Set the default command to run finetune.py
CMD ["python3", "finetune.py"]
