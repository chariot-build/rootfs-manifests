#!/usr/bin/env bash

set -euo pipefail

SCRIPT="$(realpath -- "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT")"

if [ $# -ne 1 ]; then
    echo "Usage: $0 YYYY.MM.DD" >&2
    exit 1
fi

date="$1"
repodate="${date//./\/}"

template="${SCRIPT_DIR}/arch-manifest-template.toml"
output="${SCRIPT_DIR}/../x86_64/arch/${date}.toml"

archive="archlinux-bootstrap-${date}-x86_64.tar.zst"
url="https://archive.archlinux.org/iso/${date}/${archive}"

wget "$url" -O "/tmp/${archive}"

hash="$(sha256sum "/tmp/${archive}" | awk '{print $1}')"

sed -e "s|%%repodate%%|${repodate}|g" -e "s/%%date%%/${date}/g" -e "s/%%hash%%/${hash}/g" "$template" > "$output"

echo "done"
