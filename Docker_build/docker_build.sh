#!/bin/bash

# Define variables for the versions of the tools to be used
STAR_VERSION="2.6.0c"
KALLISTO_VERSION="v0.46.1"
SAMTOOLS_VERSION="1.9"

# Docker image name and tag
IMAGE_NAME="docker.io/man4ish/rnaseq"
IMAGE_TAG="latest"

# Build the Docker image
# --build-arg: Passes build-time arguments to the Dockerfile
# -t: Tags the resulting image with a name and tag
echo "Building Docker image with STAR version ${STAR_VERSION}, Kallisto version ${KALLISTO_VERSION}, and Samtools version ${SAMTOOLS_VERSION}..."
docker build --build-arg star_version=${STAR_VERSION} \
              --build-arg kallisto_version=${KALLISTO_VERSION} \
              --build-arg samtools_version=${SAMTOOLS_VERSION} \
              -t ${IMAGE_NAME}:${IMAGE_TAG} .

# Check if the build was successful before pushing
if [ $? -eq 0 ]; then
    echo "Docker image built successfully. Pushing to Docker Hub..."
    # Push the Docker image to Docker Hub
    docker push ${IMAGE_NAME}:${IMAGE_TAG}
else
    echo "Docker image build failed. Not pushing to Docker Hub."
    exit 1
fi
