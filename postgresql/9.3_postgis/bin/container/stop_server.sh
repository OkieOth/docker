#!/bin/bash

scriptPos=${0%/*}

source "$scriptPos/conf.sh"
source "$scriptPos/../../../bin/image_conf.sh"

if ! docker ps -f name="$contNameServer" | grep "$contNameServer" > /dev/null
then
        echo
        echo -en "\033[1;34mThe server container don't run: $contNameServer \033[0m\n"
        echo
        exit 1
fi

docker stop "$contNameServer"
