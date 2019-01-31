#!/usr/bin/env bash
#
# Generates the module markdown documents by terraform-docs.
#
# Usage:
#   ./docs.sh
#

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

docker-compose build docs 2>/dev/null 1>/dev/null
docker-compose run --rm docs
