#!/bin/bash

set -o errexit -o nounset -o pipefail

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

See GitHub repo for example batch script: https://github.com/umich-biostatistics/cluster_vscode_tunnel
]])

-- local variables to be used inside the module file
local app          = myModuleName()
local installDir   = pathJoin("~/software", app)

-- general system variables
prepend_path('PATH',       pathJoin(installDir))

whatis("Name: VScode")
whatis("Description: VScode CLI tool for creating tunnels")
whatis("Package documentation: https://code.visualstudio.com/docs/configure/command-line")
whatis("GitHub: https://github.com/umich-biostatistics/cluster_vscode_tunnel")
END

# Download latest version of vscode
echo "Downloading vscode to $SW/vscode ..."
curl -Lk 'https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64' | tar -C $SW/vscode -xzf -

# Load private vscode module
ml vscode

# Initialize code tunnel using github or microsoft, comment/uncomment as needed
VSCODE_CLI_USE_FILE_KEYCHAIN=1 VSCODE_CLI_DISABLE_KEYCHAIN_ENCRYPT=1 code tunnel user login --provider github
