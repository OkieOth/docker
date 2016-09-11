#!/bin/bash

scriptPos=${0%/*}

source "$scriptPos/conf.sh"
source "$scriptPos/../../../bin/image_conf.sh"


tmpDir=`pushd "$scriptPos/.." > /dev/null && pwd && popd > /dev/null`
tmpDir="$tmpDir/tmp"

imgName="postgres:9.3"

if ! [ -d "$tmpDir" ]; then
        mkdir "$tmpDir"
fi

if ! docker ps -f name="$contNameServer" | grep "$contNameServer" > /dev/null
then
        echo -en "\033[1;34mThe needed server container don't run: $contNameServer \033[0m\n"
        exit 1
fi

docker run --name "${contNameServer}_psql" -it -e PGPASSWORD="$dbPwd" --rm --link $contNameServer:db -v ${tmpDir}:/opt/tmp "$imgName" psql -h db -U "$dbUser" "$dbName" 

