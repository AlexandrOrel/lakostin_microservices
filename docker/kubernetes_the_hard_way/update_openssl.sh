#!/bin/bash

openssl version

cd /usr/src

sudo wget https://www.openssl.org/source/openssl-1.0.2-latest.tar.gz

sudo tar -zxf openssl-1.0.2-latest.tar.gz

cd openssl-1.0.2n/

sudo apt update && sudo apt-get install make gcc

sudo ./config

sudo make

sudo make test

sudo make install

sudo mv /usr/bin/openssl /root/

sudo ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl

openssl version

