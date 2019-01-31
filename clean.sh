#!/usr/bin/env bash
#
# Deletes the generated zip file for the lambda@edge function.
#
# Usage:
#   ./clean.sh
#

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

docker-compose build dev
docker-compose run --rm dev npm run clean
