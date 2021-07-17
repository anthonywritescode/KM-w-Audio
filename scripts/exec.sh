#!/usr/bin/env bash
set -euxo pipefail

HERE="$(readlink -f "$(dirname "$0")")"

for f in "${HERE}/../dataset/"*.wav; do
	"$HERE/get-text.sh" "${f}" > "${f}.json"
done
