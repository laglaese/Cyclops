#!/bin/bash

# Input & output files
INPUT_FILE="$1"
OUTPUT_FILE="$2"
MODEL="codellama:7b-instruct"

# Read input code
CODE=$(cat "$INPUT_FILE")

# Generate response using Ollama
RESPONSE=$(ollama run $MODEL "
You are an ACSL-spec generator. 
You must output ONLY valid JSON. No explanations.

Input format: a JSON array of objects:
  { \"name\": ..., \"signature\": ..., \"decompiled\": ..., \"entry_point\": ... }

Task:
- Read each function’s 'decompiled' field.
- Add a new field:
      \"acsl_spec\": \"/*@ ... @*/\"
- Keep all other fields identical.
- Output the updated JSON array.

If behavior is unknown:
   \"acsl_spec\": \"/*@
       requires \\true;
       assigns \\nothing;
       ensures \\false;
   @*/\"

Hard rules:
- Output must be valid JSON.
- No extra keys.
- No text outside JSON.
- No markdown fences.

---BEGIN-INPUT---
$CODE
---END-INPUT---
")

echo "$RESPONSE" > "$OUTPUT_FILE"