#!/usr/bin/env bash
#
# Builds codes and creates a zip file for the lambda@edge function.
#
# Usage:
#   ./build.sh
#

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

docker-compose run --rm dev npm run build
