#!/bin/bash
#set -e

protocol=$(echo "$JAWSDB_URL" | grep "://" | sed -e's,^\(.*://\).*,\1,g')
# Remove the protocol
url_no_protocol=$(echo "${JAWSDB_URL/$protocol/}")
# Use tr: Make the protocol lower-case for easy string compare
protocol=$(echo "$protocol" | tr '[:upper:]' '[:lower:]')
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

echo "app name: $HEROKU_APP_NAME"
echo "db url: $JAWSDB_URL"
echo "  protocol: $protocol"
echo "  userpass: $userpass"
echo "  user: $user"
echo "  pass: $pass"
echo "  host: $host"
echo "  port: $port"
echo "  path: $path"

export database__client=$(echo "$protocol" | sed -r 's/\:\/\///g')
export database__connection__host="$host"
export database__connection__user="$user"
export database__connection__password="$pass"
export database__connection__database="$path"
export server__host='0.0.0.0'
export server__port=$PORT
export core__theme__active_theme="Royce_v3.0.1"
export url="http://$HEROKU_APP_NAME.herokuapp.com"
exec docker-entrypoint.sh "$@"
