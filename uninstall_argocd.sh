#!/bin/bash

export $(grep -v '^#' $(pwd)/env | xargs -0)

helm delete cicd-platform --namespace "${KUBERNETES_NAMESPACE}"
kubectl delete namespace "${KUBERNETES_NAMESPACE}"
