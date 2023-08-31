#!/bin/bash

helm upgrade --install cilium ./cilium --namespace kube-system \
--set hubble.ui.service.type=NodePort \
--set hubble.relay.enabled=true \
--set hubble.ui.enabled=true
