#!/bin/bash
set -e

BINARY="$1"

if [[ -z "$BINARY" ]]; then
    echo "ERROR: No input binary provided."
    echo "Usage: ./analyze.sh <binary>"
    exit 1
fi

mkdir -p /projects
mkdir -p /output

exec /opt/ghidra/support/analyzeHeadless \
    /projects \
    Project \
    -import "$BINARY" \
    -scriptPath /opt/ghidra/scripts \
    -postScript ghidra_export.py /output \
    -deleteProject
