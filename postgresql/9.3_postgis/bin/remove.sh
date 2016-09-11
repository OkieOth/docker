#!/bin/bash

scriptPos=${0%/*}

source "$scriptPos/image_conf.sh"


if docker rmi -f "$imageName"
then
    echo -en "\033[1;34mImage deleted: $imageName \033[0m\n"
else
    echo -en "\033[1;31mError while deleting image: $imageName \033[0m\n"
fi
