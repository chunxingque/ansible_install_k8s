#!/usr/bin/env bash
set -e

token_id=$(head -c 16 /dev/urandom | od -An -t x | tr -d ' ' | head -c6)
token_secret=$(head -c 16 /dev/urandom | od -An -t x | tr -d ' ' | head -c16)
sed -i "s/.*token_id.*/token_id: \"$token_id\"/g" playbook/group_vars/all.yaml
sed -i "s/.*token_secret.*/token_secret: \"$token_secret\"/g" playbook/group_vars/all.yaml
echo token_id: ${token_id} token_secret: ${token_secret}