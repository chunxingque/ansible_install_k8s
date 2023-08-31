#!/bin/bash

path="/kubernetes"

function checkSSL(){
    ssl_file="$1"
    echo "$ssl_file"
    openssl x509 -checkend 0 -noout  -in  $ssl_file
    openssl x509 -startdate -enddate  -noout  -in $ssl_file
    echo 
}

files=$(find  $path -name "*.pem" |grep -v "ca" |grep -v "key")

for file in $files; do 
    checkSSL  $file
done

