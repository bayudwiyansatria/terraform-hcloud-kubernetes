#!/usr/bin/env bash

set -eu
HCLOUD_TOKEN=${HCLOUD_TOKEN:-}
CLUSTER_NETWORK=${CLUSTER_NETWORK:-}

kubectl -n kube-system create secret generic hcloud --from-literal=token="${HCLOUD_TOKEN}" --from-literal=network="${CLUSTER_NETWORK}" --dry-run=client -o yaml | kubectl apply -f -

kubectl -n kube-system patch deployment coredns --type json -p '[{"op":"add","path":"/spec/template/spec/tolerations/-","value":{"key":"node.cloudprovider.kubernetes.io/uninitialized","value":"true","effect":"NoSchedule"}}]'
kubectl -n kube-system patch deployment calico-kube-controllers --type json -p '[{"op":"add","path":"/spec/template/spec/tolerations/-","value":{"key":"node.cloudprovider.kubernetes.io/uninitialized","value":"true","effect":"NoSchedule"}}]'
kubectl -n kube-system patch ds calico-node --type json -p '[{"op":"add","path":"/spec/template/spec/tolerations/-","value":{"key":"node.cloudprovider.kubernetes.io/uninitialized","value":"true","effect":"NoSchedule"}}]'

kubectl -n kube-system apply -f https://raw.githubusercontent.com/hetznercloud/hcloud-cloud-controller-manager/v1.7.0/deploy/development-networks.yaml
