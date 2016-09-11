#!/bin/bash

scriptPos=${0%/*}

source "$scriptPos/conf.sh"
source "$scriptPos/../../../bin/image_conf.sh"

if docker ps -f name="$contNameServer" | grep "$contNameServer" > /dev/null; then
    echo -en "\033[1;34mContainer already runs: $contNameServer \033[0m\n"
    exit 1
fi


if docker ps -a -f name="$contNameServer" | grep "$contNameServer" > /dev/null; then
    docker rm -f -v $contNameServer
fi
