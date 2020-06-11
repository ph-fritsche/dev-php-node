#!/bin/sh

EXPECTED_CHECKSUM="$(curl https://composer.github.io/installer.sig)"
curl -o 'getcomposer.php' 'https://getcomposer.org/installer'
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'getcomposer.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi

php getcomposer.php --quiet
RESULT=$?
rm getcomposer.php
exit $RESULT
