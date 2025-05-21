# VScode Tunnel to Great Lakes Compute Node

Initialize a VScode tunnel and private `code` LMOD module to connect to compute nodes using Great Lakes. The `vscode_tunnel.sh` script can be submitted to sbatch with the deisred resources to connect to a compute node.

## Usage

1. Copy the scripts to Great Lakes
2. Run the initialize.sh script
   ```bash
   bash initialize.sh
   ```
3. Follow the prompts to setup the tunnel with GitHub
4. **UPDATE THE ACCOUNT DIRECTIVE** and submit vscode_tunnel.sh via sbatch
   ```bash
   sbatch vscode_tunnel.sh
   ```
5. Open VScode and connect to the tunnel using GitHub Authentication
6. Once finished, disconnect from the tunnel and cancel the job on the cluster using `scancel {JOB_ID}`