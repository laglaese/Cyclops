#!/bin/bash
INPUT_FILE="$1"
OUTPUT_FILE="$2"

docker run --rm -it \
  --entrypoint /bin/bash \
  -v $HOME/.ollama:/root/.ollama \
  -v "$PWD":/workspace \
  -w /workspace \
  ollama-img \
  -c "ollama serve & sleep 2 && bash process_file.sh $INPUT_FILE $OUTPUT_FILE"