#!/bin/bash

scriptPos=${0%/*}


dataDir=`pushd $scriptPos/../data > /dev/null && pwd && popd > /dev/null`

echo "dataDir: $dataDir"

pushd "$scriptPos/../image" > /dev/null
docker run --name psql_9.3_test -e POSTGRES_PASSWORD=batman999 -e POSTGRES_USER=batman -e POSTGRES_DB=pg_test -e PGDATA=/opt/pgdata -v ${dataDir}:/opt/pgdata -d psql_server:9.3 
popd > /dev/null
