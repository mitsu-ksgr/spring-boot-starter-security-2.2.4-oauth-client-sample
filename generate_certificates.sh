#!/bin/bash
set -eu

GEN_PATH=/app/certs

if ! builtin command -v openssl > /dev/null; then
    echo 'Error: openssl is not installed.' >&2
    exit 1
fi

if [ -n "${1+$1}" ]; then
    GEN_PATH="$1"
fi
mkdir -p $GEN_PATH && cd $GEN_PATH

# generate a self-signed certificate
openssl req \
    -x509 -nodes -days 365 -sha256 \
    -subj '/C=JP/ST=Tokyo/L=Shinjuku/CN=www.test.org' \
    -newkey rsa:2048 -keyout mycert.pem -out mycert.pem \
    2>/dev/null

# generate a PKCS#12 certificate
openssl pkcs12 -export \
    -out mycert.pfx -in mycert.pem \
    -password pass:password \
    -name "mycert" \
    2>/dev/null

echo "Successfully generated."
echo "* self-signed certificate : ${GEN_PATH}/mycert.pem"
echo "* PKCS#12 certificate     : ${GEN_PATH}/mycert.pfx"
echo "                              - Alias     : \"mycert\""
echo "                              - Password  : \"password\""

