#!/bin/bash

#SBATCH --job-name=vscode_tunnel
#SBATCH --output=logs/%x-%J.out
#SBATCH --partition=debug
#SBATCH --mem=14G
#SBATCH --cpus-per-task=2
#SBATCH --time=02:00:00
#SBATCH --account=ACCOUNT_HERE

set -o errexit -o nounset -o pipefail

export VSCODE_CLI_USE_FILE_KEYCHAIN=1 
export VSCODE_CLI_DISABLE_KEYCHAIN_ENCRYPT=1 

ml use ~/Lmode
ml vscode

# Auto-accept the license terms & launch the tunnel
code tunnel --accept-server-license-terms --name $(hostname -s)
