#!/bin/bash

# Exit if any subcommand or pipeline returns a non-zero status
set -e

if [ ! -f /.mongodb_password_set ]; then
  /set_mongodb_password.sh
fi

# Substring of $1 starting at character 0 and getting 1 character
# set: If no options or arguments are supplied, set displays the names and values of all shell variables and functions, sorted according to the current locale, in a format that can be reused as input
# double dash (--) means "end of command line flags", tells set command not parse what comes after command line options
if [ "${1:0:1}" = '-' ]; then
    set -- mongod "$@"
fi

if [ "$1" = 'mongod' ]; then
    chown -R mongodb /data/db

    numa='numactl --interleave=all'
    if $numa true &> /dev/null; then
        set -- $numa "$@"
    fi

    exec gosu mongodb "$@"
fi

exec "$@"