#!/bin/bash

set -o errexit -o nounset -o pipefail
 
# Default provider
PROVIDER="github"

# Parse command-line options for provider
while [ $# -gt 0 ]; do
  case "$1" in
    -gh|--github)
      PROVIDER="github"
      shift
      ;;
    -ms|--microsoft)
      PROVIDER="microsoft"
      shift
      ;;
    -h|--help)
      echo "Usage: $0 [-gh|--github] [-ms|--microsoft]"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [-gh|--github] [-ms|--microsoft]"
      exit 1
      ;;
  esac
done

# Create private module directory and use
mkdir -p $HOME/Lmod/vscode
ml use $HOME/Lmod

# Set and create local software directory
SW="$HOME/software"
mkdir -p $SW/vscode

# Create private vscode module
echo "Creating private module for VScode..."
cat > ~/Lmod/vscode/vscode.lua << "END"
-- Help
help([[
VScode CLI tool, used for --tunnel functionality to create a tunnel via GitHub or Microsoft and connect to a compute node from a local VScode instance.

Includes:
  - code: VSCode CLI for tunnel functionality
  - codetunnel: Interactive helper script for submitting VSCode tunnel jobs

See GitHub repo for example batch script: https://github.com/umich-biostatistics/cluster_vscode_tunnel
]])

-- local variables to be used inside the module file
local app          = myModuleName()
local installDir   = pathJoin("~/software", app)

-- general system variables
prepend_path('PATH',       pathJoin(installDir))

whatis("Name: VScode")
whatis("Description: VScode CLI tool for creating tunnels with interactive job submission helper")
whatis("Package documentation: https://code.visualstudio.com/docs/configure/command-line")
whatis("GitHub: https://github.com/umich-biostatistics/cluster_vscode_tunnel")
END

# Download latest version of vscode
echo "Downloading vscode to $SW/vscode ..."
curl -Lk 'https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64' | tar -C $SW/vscode -xzf -

# Copy codetunnel helper script to the vscode directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/codetunnel" ]; then
    echo "Installing codetunnel helper script..."
    cp "$SCRIPT_DIR/codetunnel" "$SW/vscode/"
    chmod +x "$SW/vscode/codetunnel"
    
    # Store the repository path for codetunnel to find vscode_tunnel.sh
    echo "export CLUSTER_VSCODE_TUNNEL_DIR=\"$SCRIPT_DIR\"" > "$SW/vscode/cluster_tunnel_config"
    
    echo "✓ codetunnel helper script installed"
else
    echo "Warning: codetunnel script not found in $SCRIPT_DIR"
fi

# Load private vscode module
ml vscode

# Initialize code tunnel using selected provider
VSCODE_CLI_USE_FILE_KEYCHAIN=1 VSCODE_CLI_DISABLE_KEYCHAIN_ENCRYPT=1 code tunnel user login --provider "$PROVIDER"
