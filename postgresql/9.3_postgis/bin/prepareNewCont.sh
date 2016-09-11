#!/bin/bash

scriptPos=${0%/*}

if [ $# -eq 0 ]; then 
        echo -en "\033[1;33mThe name of the sub directory for the new container is as parameter needed, cancel\033[0m\n"
        exit 1
fi
destDir=$scriptPos/../container/$1

if [ -d $destDir ]; then
        echo -en "\033[1;31mDestination directory already exists: $destDir \nCancel.\033[0m\n"
        exit 1
fi

echo -en "\033[1;34mPrepare directory: $destDir \033[0m\n"

mkdir -p  $destDir/bin
cp $scriptPos/container/example_conf.sh $destDir/bin/conf.sh
pushd $destDir/bin > /dev/null
ln -s ../../../bin/container/del_server.sh
ln -s ../../../bin/container/start_bash.sh
ln -s ../../../bin/container/start_psql.sh
ln -s ../../../bin/container/start_server.sh
ln -s ../../../bin/container/stop_server.sh
popd

mkdir -p  $destDir/data

mkdir -p  $destDir/import
cat << README > $destDir/import/README.md
Shell scripts or SQL files in this directory are used to initialize database

Allowed file types:
*.sh, *.sql, *.sql.gz, *.sql.bz2
README


mkdir -p  $destDir/tmp
cat << README2 > $destDir/tmp/README.md
This directory is mounted to /opt/tmp of the container
README2


