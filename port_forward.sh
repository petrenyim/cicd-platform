#!/bin/bash

export $(grep -v '^#' $(pwd)/env | xargs -0)

# ArgoCD
kubectl port-forward service/cicd-platform-argocd-server -n "${KUBERNETES_NAMESPACE}" 8080:443
