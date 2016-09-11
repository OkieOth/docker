#!/bin/bash

scriptPos=${0%/*}

source "$scriptPos/image_conf.sh"


aktImgName=`docker images |  grep -G "$imageBase *$imageTag *" | awk '{print $1":"$2}'`

if [ "$aktImgName" == "$imageBase:$imageTag" ]
then
        echo "run container from image: $aktImgName"
else
    if docker build -t $imgageName $scriptPos/../image
    then
        echo -en "\033[1;34mImage created: $imageName \033[0m\n"
    else
        echo -en "\033[1;31mError while create image: $imageName \033[0m\n"
        exit 1
    fi
fi

tmpDir=`pushd "$scriptPos/.." > /dev/null && pwd && popd > /dev/null`
tmpDir="$tmpDir/tmp"

if ! [ -d "$tmpDir" ]; then
        mkdir "$tmpDir"
fi

echo "$tmpDir"

docker run -it --rm -v ${tmpDir}:/opt/tmp "$imageName" /bin/bash


