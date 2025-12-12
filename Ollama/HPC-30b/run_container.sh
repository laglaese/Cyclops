#!/bin/bash
#SBATCH --job-name=hgx-job
#SBATCH --account=punakha_general
#SBATCH --qos=punakha_hgx_general
#SBATCH --partition=hgx
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=04:00:00
#SBATCH --output=slurm-run-%j.out

#load docker
module load docker/27.3.1
start_rootless_docker.sh --quiet

#build ollama image
docker build -t ollama-img:latest ~/project

#define input,output files, and 30b model
INPUT_FILE="$1"
OUTPUT_FILE="$2"
MODEL="qwen3:30b"


echo "Starting container..."

#run the container 
docker run --rm --gpus all \
  --ipc=host \
  --network host \
  --entrypoint /bin/bash \
  -v ~/project:/workspace \
  -v $HOME/.ollama:/root/.ollama \
  -w /workspace \
  ollama-img \
  -c "
	echo 'Starting Ollama server...' ;
        ollama serve & sleep 3 ;
        echo 'Pulling model if missing...' ;
        ollama pull $MODEL ;
        echo 'Processing file...' ;
        bash process_file.sh $INPUT_FILE $OUTPUT_FILE ;
  "

echo "Job complete. Output: $OUTPUT_FILE"
