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
        echo "All Databases (mysql -h ${HOST_NAME} -u ${ROOT_USER} -p${ROOT_PASSWORD}  < ${DATABASE_SCHEMA})";
        mysql -h ${HOST_NAME} -u ${ROOT_USER} -p${ROOT_PASSWORD}  < ${DATABASE_SCHEMA};
    else
        echo "Single Database (mysql -h ${HOST_NAME} -u ${ROOT_USER} -p${ROOT_PASSWORD} ${DATABASE} < ${DATABASE_SCHEMA})";
        mysql -h ${HOST_NAME} -u ${ROOT_USER} -p${ROOT_PASSWORD} ${DATABASE} < ${DATABASE_SCHEMA};
    fi
else
	echo "$DATABASE_SCHEMA not found."
fi

echo "COMPOSER UPDATE";
composer update;
rm -fv wp-content/mu-plugins/index.php

if [ -f ./vendor/bin/sarcofag ]; then
    ./vendor/bin/sarcofag install
fi

if [ -z $ISSTAGE ]
then
  cd wp-content/themes/$THEME_NAME
  touch style.css
  
  echo "NPM Set repo path";
  npm config set registry http://registry.npmjs.org/

  echo "NPM UPDATE";
  npm update

  if [ -z ${FRONTEND_BUILDER+x} ]; then
    echo "RUN node_modules/.bin/grunt";
    ./node_modules/.bin/grunt
  else
    echo "RUN ${FRONTEND_BUILDER}";
    ${FRONTEND_BUILDER}
  fi

  cd ../../../
fi

echo "Creating .done file in /tmp to notify that everything done...."
touch /tmp/.done

while true; do sleep 1000; done
