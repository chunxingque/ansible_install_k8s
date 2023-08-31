#!/bin/bash

kubectl create secret docker-registry harbor-secret \
    -n default \
    --docker-username=admin \
    --docker-password=password \
    --docker-server=192.168.15.124