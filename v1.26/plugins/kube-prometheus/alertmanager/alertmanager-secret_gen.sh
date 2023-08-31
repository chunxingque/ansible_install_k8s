#!/bin/bash
kubectl create secret generic alertmanager-main     \
--type Opaque    \
--from-file=alertmanager.yaml   \
--dry-run='client'    \
-o yaml    \
-n monitoring > alertmanager-secret_gen.yaml
