#!/bin/bash

scriptPos=${0%/*}

containerName=psql_9_3_server_test
imageName=postgres
imageTag=9.3

dbUser=batman
dbUserPwd=betman999
dbName=pg_test

if docker ps -f name="/$containerName" | grep $containerName > /dev/null; then
    echo "$containerName already runs"
    exit 1
fi

if ! [ -d "$scriptPos/../data" ]; then
    mkdir -p $scriptPos/../data
    chmod -R a+w "$scriptPos/../data"
fi

dataDir=`pushd $scriptPos/.. > /dev/null && pwd && popd > /dev/null`
dataDir=$dataDir/data

echo "dataDir: $dataDir"

if docker ps -a | grep "$containerName" > /dev/null; then
    docker start $containerName

else
    docker run --name "$containerName" -e POSTGRES_PASSWORD="$dbUserPwd" -e POSTGRES_USER="$dbUser" -e POSTGRES_DB="$dbName" -e PGDATA=/opt/pgdata -v ${dataDir}:/opt/pgdata -d "$imageName":"$imageTag" 
fi

