#!/bin/bash
wget https://github.com/cilium/cilium-cli/releases/download/v0.15.4/cilium-linux-amd64.tar.gz
tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
cilium version --client
