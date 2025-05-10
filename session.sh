#!/bin/bash

# Name of docker container
ContainerName="mrg_tutorial"

# path to the compose file
CF=$(dirname "$0")/docker-compose_nvidia.yml

# Check if nvidia-container-runtime is installed
if ! command -v nvidia-container-runtime &> /dev/null; then
    echo "nvidia-container-runtime not found, using no GPU container"
    CF=$(dirname "$0")/docker-compose.yml
fi

# Check if the container is not already running
if [ $(docker-compose -f $CF ps | grep $ContainerName | grep -c Up ) == 0 ]; then 
    docker-compose -f $CF up -d;
fi

# Start terminal session marked with "MRG Session in the arguments
docker exec -it $ContainerName /bin/bash -s "MRG Session";

# Check if there are any active MRG bash sessions
if [ $(docker-compose -f $CF top | grep -c "/bin/bash -s MRG Session") == 0 ]; then 
    # The last session has been closed, stop the container
    docker-compose -f $CF stop;
fi
