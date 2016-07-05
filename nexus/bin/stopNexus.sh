#!/bin/bash

if docker ps -f name="/nexus" | grep nexus > /dev/null; then
    docker stop nexus
else
    echo "nexus doesn't run"
    exit 1
fi
