#!/bin/bash
set -e

until mysql -h${HOST_NAME} -u${ROOT_USER} -p${ROOT_PASSWORD} &> /dev/null
do
  printf "."
  sleep 1
done

if [ -f "$DATABASE_SCHEMA" ]
then
    if [ -z "${DATABASE+xxx}" ]; then
        mysql -h ${HOST_NAME} -u ${ROOT_USER} -p${ROOT_PASSWORD}  < ${DATABASE_SCHEMA};
    else
        mysql -h ${HOST_NAME} -u ${ROOT_USER} -p${ROOT_PASSWORD} ${DATABASE} < ${DATABASE_SCHEMA};
    fi
else
	echo "$DATABASE_SCHEMA not found."
fi

echo "COMPOSER UPDATE";

composer update;

if [ -z "$ISSTAGE" ]
then
  cd wp-content/themes/$THEME_NAME
  touch style.css

  echo "NPM UPDATE";

  npm update
  ./node_modules/.bin/grunt

  cd ../../../
fi

rm -fv wp-content/mu-plugins/index.php
./vendor/bin/sarcofag install

echo "Creating .done file in /tmp to notify that everything done...."
touch /tmp/.done

while true; do sleep 1000; done
