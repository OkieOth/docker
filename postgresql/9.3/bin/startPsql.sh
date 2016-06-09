#!/bin/bash

scriptPos=${0%/*}



docker run -it -e PGPASSWORD=batman999 --rm --link psql_9.3_test:postgres psql_server:9.3 psql -h postgres -U batman pg_test 
