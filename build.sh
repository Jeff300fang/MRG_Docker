#!/bin/bash

# Make sure the builder containers are installed, created, and registered by running:
# docker run --privileged --rm tonistiigi/binfmt --install all
# docker buildx create --name mybuilder --use --bootstrap
# docker buildx use mybuilder


# Choose one of the options below
#TODO: update so the build script takes arguments for load vs push and the tag name

# Can't use load with multiple platforms at once so specify the version you want (linux/amd64 or linux/arm64)
#docker buildx build --platform=linux/amd64 -t mwoodward6/mrg:humble --load .

# generate and push both versions to dockerhub, make sure to set the tag
docker buildx build --platform linux/amd64,linux/arm64 -t jeff300fang/mrg:jazzy_tutorial --push .
