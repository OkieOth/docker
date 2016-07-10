#!/bin/bash

scriptPos=${0%/*}

containerName=psql_9_3_server_test
imageName=postgres
imageTag=9.3

dbUser=batman
dbUserPwd=betman999
dbName=pg_test

docker run -it -e PGPASSWORD="$dbUserPwd" --rm --link "$containerName":postgres "$imageName":"$imageTag" psql -h postgres -U "$dbUser" "$dbName" 
#docker run -it -e PGPASSWORD="$dbUserPwd" --rm --link "$containerName":postgres "$imageName":"$imageTag" /bin/bash 
