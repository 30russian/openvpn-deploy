#!/bin/bash

# First argument: Client identifier
# CWD must be client-configs

KEY_DIR=..
OUTPUT_DIR=.
BASE_CONFIG=./client${2}.conf

cat ${BASE_CONFIG} \
    <(echo -e '<ca>') \
    ${KEY_DIR}/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    ${KEY_DIR}/${1}.crt \
    <(echo -e '</cert>\n<key>') \
    ${KEY_DIR}/${1}.key \
    <(echo -e '</key>\n<tls-auth>') \
    ${KEY_DIR}/ta.key \
    <(echo -e '</tls-auth>\n<dh>') \
    ${KEY_DIR}/dh2048.pem \
    <(echo -e '</dh>') \
    > ${OUTPUT_DIR}/${1}.ovpn