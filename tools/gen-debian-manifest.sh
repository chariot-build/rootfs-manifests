#!/usr/bin/env bash

set -euo pipefail

SCRIPT="$(realpath -- "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT")"

if [ $# -ne 1 ]; then
    echo "Usage: $0 YYYYMMDDTHHMMSSZ" >&2
    exit 1
fi

date="$1"

template="${SCRIPT_DIR}/debian-manifest-template.toml"
output="${SCRIPT_DIR}/../x86_64/debian/${date}.toml"

archive="debian-rootfs-${date}-amd64.tar.xz"
url="https://github.com/chariot-build/debian-rootfs/releases/download/$date/rootfs-amd64.tar.xz"

wget "$url" -O "/tmp/${archive}"

hash="$(sha256sum "/tmp/${archive}" | awk '{print $1}')"

sed -e "s/%%date%%/${date}/g" -e "s/%%hash%%/${hash}/g" "$template" > "$output"

echo "done"
