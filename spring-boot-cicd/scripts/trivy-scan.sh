#!/usr/bin/env sh
set -eu

IMAGE="${1:?Usage: trivy-scan.sh image:tag}"
REPORT_DIR="${TRIVY_REPORT_DIR:-trivy-reports}"
SEVERITY="${TRIVY_SEVERITY:-HIGH,CRITICAL}"

mkdir -p "$REPORT_DIR"

if ! command -v trivy >/dev/null 2>&1; then
  echo "ERROR: trivy is not installed on this Jenkins agent." >&2
  exit 2
fi

echo "Creating full Trivy report for $IMAGE"
trivy image --no-progress --format table --output "$REPORT_DIR/trivy-image-report.txt" "$IMAGE"

echo "Applying vulnerability gate: $SEVERITY"
trivy image --no-progress --exit-code 1 --severity "$SEVERITY" --ignore-unfixed "$IMAGE"
