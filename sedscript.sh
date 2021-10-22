#!/usr/bin/env bash
set -x
# Set the image tag if not set
IMAGE_TAG=$1
sed "s/{VERSION}/${IMAGE_TAG}/g" k8s-base/nodejsapp-sed.yaml > k8s-base/nodejsapp.yaml
