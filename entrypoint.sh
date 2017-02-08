#!/bin/bash
set -e

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