#!/bin/bash
set -e

# --- Paths ---
REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"     # Absolute path to repo root
BINARIES_PATH="$REPO_ROOT/binaries"            # Folder containing the binary
OUTPUT_PATH="$REPO_ROOT/output"                # Output folder
PROJECTS_PATH="$REPO_ROOT/projects"            # Ghidra projects folder

# --- Find the binary ---
BINARY_FILE=$(find "$BINARIES_PATH" -maxdepth 1 -type f | head -n 1)

if [ -z "$BINARY_FILE" ]; then
    echo "ERROR: No binary found in $BINARIES_PATH"
    exit 1
fi

echo "Found binary: $BINARY_FILE"

# --- Ensure output and projects folders exist ---
mkdir -p "$OUTPUT_PATH" "$PROJECTS_PATH"

# --- Run Docker ---
docker run --rm \
    -v "$BINARY_FILE:/work/binaries/$(basename "$BINARY_FILE")" \
    -v "$OUTPUT_PATH:/output" \
    -v "$PROJECTS_PATH:/work/projects" \
    ghidra-headless \
    "/work/binaries/$(basename "$BINARY_FILE")"


echo "Analysis complete. Output JSON is in $OUTPUT_PATH"
