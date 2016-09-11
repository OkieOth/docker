#!/bin/bash

scriptPos=${0%/*}

source "$scriptPos/conf.sh"
source "$scriptPos/../../../bin/image_conf.sh"

aktImgName=`docker images |  grep -G "$imageBase *$imageTag *" | awk '{print $1}'`
aktImgVers=`docker images |  grep -G "$imageBase *$imageTag *" | awk '{print $2}'`

if [ "$aktImgName" == "$imageBase" ] && [ "$aktImgVers" == "$imageTag" ]
then
        echo "run container from image: $aktImgName:$aktImgVers"
else
	if docker build -t $imageName $scriptPos/../../../image
    then
        echo -en "\033[1;34mImage created: $imageName \033[0m\n"
    else
        echo -en "\033[1;31mError while create image: $imageName \033[0m\n"
        exit 1
    fi
fi

dataDir=`pushd "$scriptPos/.." > /dev/null && pwd && popd > /dev/null`
importDir="$dataDir/import"
dataDir="$dataDir/data"

echo "importDir: $importDir"

docker run -it --rm --entrypoint=/bin/bash -e POSTGRES_PASSWORD="$dbPwd" -e POSTGRES_USER="$dbUser" -e POSTGRES_DB="$dbName" -e PGDATA=/opt/pgdata -v ${dataDir}:/opt/pgdata -v ${importDir}:/import "$imageName" 
