#!/bin/bash
set -eu

SSL_DIR=$(dirname ${0})

pushd ${SSL_DIR}

if [ ! -f ./openssl.cnf ]; then
    echo "Please copy ${SSL_DIR}/openssl.cnf.dist to ${SSL_DIR}/openssl.cnf"
    echo "and update the [alt_names] section at the end."

    exit 1
fi

rm -f ssl.*

echo "Generating TLS certificate..."

openssl req -config ./openssl.cnf -x509 -sha256 -nodes -newkey rsa:2048 -keyout ./ssl.key -out ./ssl.crt -extensions v3_req -days 90

chmod 400 ./ssl.key

echo "Restarting web container..."
vagrant ssh -c 'docker restart docker_web_1'

echo "Certificate information..."
openssl x509 -noout -text -in ./ssl.crt

popd
