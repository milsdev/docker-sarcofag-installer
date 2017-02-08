#!/bin/bash
set -e

if [ -f "$DATABASE_SCHEMA" ]
then
	mysql -h ${HOST_NAME} -u ${ROOT_USER} -p${ROOT_PASSWORD} < ${DATABASE_SCHEMA}
else
	echo "$DATABASE_SCHEMA not found."
fi

echo "COMPOSER UPDATE";

composer update;
cd wp-content/themes/$THEME_NAME

echo "NPM UPDATE";

npm update
./node_modules/.bin/grunt

cd ../../../
rm -fv wp-content/mu-plugins/index.php

./vendor/bin/sarcofag install

sleep 5000;