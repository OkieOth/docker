#!/bin/bash

scriptPos=${0%/*}


source "$scriptPos/conf.sh"
source "$scriptPos/../../../bin/image_conf.sh"

docker ps -f name="$contNameServer" | grep "$contNameServer" > /dev/null && echo -en "\033[1;31m  Container läuft bereits: $contNameServer \033[0m\n" && exit 1

dataDir=`pushd "$scriptPos/.." > /dev/null && pwd && popd > /dev/null`
importDir="$dataDir/import"
dataDir="$dataDir/data"

aktImgName=`docker images |  grep -G "$imageBase *$imageTag *" | awk '{print $1":"$2}'`

if [ "$aktImgName" == "$imageBase:$imageTag" ]
then
        echo "run container from image: $aktImgName"
else
	if docker build -t $imageName $scriptPos/../../../image
    then
        echo -en "\033[1;34mImage created: $imageName \033[0m\n"
    else
        echo -en "\033[1;31mError while create image: $imageName \033[0m\n"
        exit 1
    fi
fi

if docker ps -a -f name="$contNameServer" | grep "$contNameServer" > /dev/null; then
    docker start $contNameServer
else
    if [ -z "$toHostPort" ]; then
        docker run --name "$contNameServer" --cpuset-cpus=0-2 -e POSTGRES_PASSWORD="$dbPwd" -e POSTGRES_USER="$dbUser" -e POSTGRES_DB="$dbName" -e PGDATA=/opt/pgdata -v ${dataDir}:/opt/pgdata -v ${importDir}:/import "$imageName"
    else
        docker run --name "$contNameServer" --cpuset-cpus=0-2 -p $toHostParam:5432 -e POSTGRES_PASSWORD="$dbPwd" -e POSTGRES_USER="$dbUser" -e POSTGRES_DB="$dbName" -e PGDATA=/opt/pgdata -v ${dataDir}:/opt/pgdata -v ${importDir}:/import "$imageName"
    fi
fi


