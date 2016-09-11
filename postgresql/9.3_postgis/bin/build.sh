#!/bin/bash

scriptPos=${0%/*}

source "$scriptPos/image_conf.sh"

imagePathBase=`pushd "$scriptPos/.." > /dev/null; pwd; popd > /dev/null`

if docker build -t $imageName "$imagePathBase/image"
then
    echo -en "\033[1;34m  Image created: $imageName \033[0m\n"
else
    echo -en "\033[1;31m  Error while create Image: $imageName \033[0m\n"
fi

