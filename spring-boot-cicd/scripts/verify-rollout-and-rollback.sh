#!/usr/bin/env sh
set -eu

NAMESPACE="${NAMESPACE:-spring-boot}"
DEPLOYMENT="${DEPLOYMENT_NAME:-spring-boot-app}"
BRANCH="${GIT_BRANCH_NAME:-main}"
TIMEOUT="${ROLLOUT_TIMEOUT:-180s}"
ARGO_APP="${ARGO_APP:-spring-boot-app}"

sync_argocd_if_available() {
  if [ -n "$ARGO_APP" ] && command -v argocd >/dev/null 2>&1; then
    argocd app sync "$ARGO_APP"
    argocd app wait "$ARGO_APP" --health --timeout 180
  fi
}

echo "Checking rollout for deployment/$DEPLOYMENT in namespace $NAMESPACE"
sync_argocd_if_available

if kubectl rollout status "deployment/${DEPLOYMENT}" -n "$NAMESPACE" --timeout "$TIMEOUT"; then
  echo "Rollout is healthy."
  exit 0
fi

echo "ERROR: rollout failed. Reverting last GitOps commit." >&2
git revert --no-edit HEAD
git push origin "HEAD:${BRANCH}"

echo "Waiting for Argo CD/Kubernetes to restore the previous release."
sync_argocd_if_available
kubectl rollout status "deployment/${DEPLOYMENT}" -n "$NAMESPACE" --timeout "$TIMEOUT"
