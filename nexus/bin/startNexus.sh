#!/bin/bash

scriptPos=${0%/*}

if docker ps -f name="/nexus" | grep nexus > /dev/null; then
    echo "nexus already runs"
    exit 1
fi

pushd $scriptPos > /dev/null
cd ..
dataDir=`pwd`
dataDir=$dataDir/data

popd > /dev/null


if ! [ -d "$dataDir" ]; then
    mkdir "$dataDir"
    chmod a+w "$dataDir"
fi

if docker ps -a | grep nexus > /dev/null; then
    docker start nexus

else
    docker run -d -p 8081:8081 --name nexus -v "$dataDir":/sonatype-work sonatype/nexus
fi

