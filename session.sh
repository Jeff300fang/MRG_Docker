#!/bin/bash

# Name of docker container
ContainerName="mrg_tutorial"

# path to the compose file
CF=$(dirname "$0")/docker-compose.yml

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
