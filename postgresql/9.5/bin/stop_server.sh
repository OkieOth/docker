#!/bin/bash

scriptPos=${0%/*}

containerName=psql_9_5_server_test

if docker ps -f name="/$containerName" | grep "$containerName" > /dev/null; then
    docker stop "$containerName"
else
    echo "$containerName doesn't run"
    exit 1
fi

