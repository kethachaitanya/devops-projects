#!/usr/bin/env sh
set -eu

IMAGE="${1:?Usage: update-gitops-image.sh image:tag manifest.yml [branch]}"
MANIFEST="${2:?Usage: update-gitops-image.sh image:tag manifest.yml [branch]}"
BRANCH="${3:-main}"

if [ ! -f "$MANIFEST" ]; then
  echo "ERROR: manifest file not found: $MANIFEST" >&2
  exit 10
fi

case "$IMAGE" in
  *:latest|*:)
    echo "ERROR: production releases must not use latest or an empty image tag: $IMAGE" >&2
    exit 11
    ;;
  *:*)
    ;;
  *)
    echo "ERROR: image must include an immutable tag: $IMAGE" >&2
    exit 12
    ;;
esac

if ! grep -q '^[[:space:]]*image:' "$MANIFEST"; then
  echo "ERROR: no image field found in manifest: $MANIFEST" >&2
  exit 13
fi

sed -i.bak -E "s#^([[:space:]]*image:[[:space:]]*).+#\1${IMAGE}#" "$MANIFEST"
rm -f "${MANIFEST}.bak"

if git diff --quiet -- "$MANIFEST"; then
  echo "No manifest change needed. Image is already $IMAGE"
  exit 0
fi

git add "$MANIFEST"
git commit -m "Update spring-boot-app image to ${IMAGE}"

attempt=1
while [ "$attempt" -le 3 ]; do
  if git push origin "HEAD:${BRANCH}"; then
    echo "GitOps update pushed successfully."
    exit 0
  fi

  echo "Push failed. Rebase and retry attempt $attempt of 3."
  git pull --rebase origin "$BRANCH"
  attempt=$((attempt + 1))
done

echo "ERROR: failed to push GitOps update after 3 attempts." >&2
exit 14
