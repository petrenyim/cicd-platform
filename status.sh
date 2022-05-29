#!/bin/bash

export $(grep -v '^#' $(pwd)/env | xargs -0)

watch -n0.5 "kubectl get pods,svc,jenkins -n ${KUBERNETES_NAMESPACE}; echo \"\nLogs: \"; \
	     kubectl logs --tail 10 -n ${KUBERNETES_NAMESPACE} $(kubectl get pods -n ${KUBERNETES_NAMESPACE} -l app.kubernetes.io/name=jenkins-operator --no-headers | cut -d' ' -f1)"
