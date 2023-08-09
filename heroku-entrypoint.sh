#!/bin/bash
#set -e

userpass=$(echo "$url_no_protocol" | grep "@" | cut -d"/" -f1 | rev | cut -d"@" -f2- | rev)
pass=$(echo "$userpass" | grep ":" | cut -d":" -f2)
if [ -n "$pass" ]; then
  user=$(echo "$userpass" | grep ":" | cut -d":" -f1)
else
  user="$userpass"
fi

# Extract the host
hostport=$(echo "${url_no_protocol/$userpass@/}" | cut -d"/" -f1)
host=$(echo "$hostport" | cut -d":" -f1)
port=$(echo "$hostport" | grep ":" | cut -d":" -f2)
path=$(echo "$url_no_protocol" | grep "/" | cut -d"/" -f2-)

export database__client="mysql"
export database__connection__host="$host"
export database__connection__user="$user"
export database__connection__password="$pass"
export database__connection__database="$path"
export server__host='0.0.0.0'
export server__port=$PORT

exec docker-entrypoint.sh "$@"
