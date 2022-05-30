#!/bin/bash

export $(grep -v '^#' $(pwd)/env | xargs -0)

check_command_available() {
  if ! command -v "${1}" &> /dev/null; then
    echo "Please install ${1}."
    exit
  fi
}
check_dependencies() {
  check_command_available "helm"
  check_command_available "kubectl"
}

install_argocd() {
  echo "Add ArgoCD helm repository"
  helm repo add argo https://argoproj.github.io/argo-helm

  echo "Install ArgoCD helm application"
  helm install cicd-platform argo/argo-cd -f values.yaml --create-namespace --namespace "${KUBERNETES_NAMESPACE}"
}

install_jenkins() {
  echo "Installing Jenkins operator ArgoCD application"
  kubectl apply -f argocd/jenkins-operator/application.yaml --namespace "${KUBERNETES_NAMESPACE}"

  echo "Deploying Jenkins master instance"
  cat argocd/jenkins/application.yaml | sed  "s#JENKINS_GIT_URL#$(git remote get-url origin)#" | kubectl apply -f -
}

main() {
  check_dependencies
  install_argocd
  install_jenkins

  echo "-----------------------------------------------------"
  echo "ArgoCD credentials:"
  echo "Username: admin"
  echo "Password: password"
}

main $@
