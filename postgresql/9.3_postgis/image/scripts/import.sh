#!/bin/bash

# copied and extended from the original Postgresql docker image

set -e

if [ "${1:0:1}" = '-' ]; then
    set -- postgres "$@"
fi

if [ "$1" = 'postgres' ]; then
    mkdir -p "$PGDATA"
    chmod 700 "$PGDATA"
    chown -R postgres "$PGDATA"

    chmod g+s /run/postgresql
    chown -R postgres /run/postgresql

    # look specifically for PG_VERSION, as it is expected in the DB dir
    if [ ! -s "$PGDATA/PG_VERSION" ]; then
        eval "gosu postgres initdb $POSTGRES_INITDB_ARGS"

        # check password first so we can output the warning before postgres
        # messes it up
        if [ "$POSTGRES_PASSWORD" ]; then
            pass="PASSWORD '$POSTGRES_PASSWORD'"
            authMethod=md5
        else
            pass=
            authMethod=trust
        fi

        { echo; echo "host all all 0.0.0.0/0 $authMethod"; } >> "$PGDATA/pg_hba.conf"

        # internal start of server in order to allow set-up using psql-client       
        # does not listen on external TCP/IP and waits until start finishes
        gosu postgres pg_ctl -D "$PGDATA" \
            -o "-c listen_addresses='localhost'" \
            -w start

        : ${POSTGRES_USER:=postgres}
        : ${POSTGRES_DB:=$POSTGRES_USER}
        export POSTGRES_USER POSTGRES_DB

        psql=( psql -v ON_ERROR_STOP=1 )

        if [ "$POSTGRES_DB" != 'postgres' ]; then
            "${psql[@]}" --username postgres <<EOSQL
                CREATE DATABASE "$POSTGRES_DB" ;
EOSQL
            echo
        fi

        if [ "$POSTGRES_USER" = 'postgres' ]; then
            op='ALTER'
        else
            op='CREATE'
        fi
        "${psql[@]}" --username postgres <<-EOSQL
            $op USER "$POSTGRES_USER" WITH SUPERUSER $pass ;
EOSQL
        echo

        psql+=( --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" )

        echo
        for f in /docker-entrypoint-initdb.d/*; do
            case "$f" in
                *.sh)     echo "$0: running $f"; . "$f" ;;
                *.sql)    echo "$0: running $f"; "${psql[@]}" < "$f"; echo ;;
                *.sql.gz) echo "$0: running $f"; gunzip -c "$f" | "${psql[@]}"; echo ;;
                *)        echo "$0: ignoring $f" ;;
            esac
            echo
        done

        for f in /import/*; do
            case "$f" in
                *.sh)     echo "$0: running $f"; . "$f" ;;
                *.sql)    echo "$0: running $f"; "${psql[@]}" < "$f"; echo ;;
                *.sql.bz2) echo "$0: running $f"; bunzip2 -c "$f" | "${psql[@]}"; echo ;;
                *.sql.gz) echo "$0: running $f"; gunzip -c "$f" | "${psql[@]}"; echo ;;
                *)        echo "$0: ignoring $f" ;;
            esac
            echo
        done

        gosu postgres pg_ctl -D "$PGDATA" -m fast -w stop

        echo
        echo 'PostgreSQL init process complete; ready for start up.'
        echo
    fi

    exec gosu postgres "$@"
fi

exec "$@"

