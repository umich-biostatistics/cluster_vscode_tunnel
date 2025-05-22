# VScode Tunnel to Great Lakes Compute Node

Initialize a VScode tunnel using GitHub or Microsoft and create a private `vscode` LMOD module to connect to Great Lakes compute nodes.
The `vscode_tunnel.sh` script can be submitted to sbatch with the deisred resources to connect to a compute node and start the tunnel.

## Usage

1. Copy/clone the scripts to Great Lakes
2. Run the `initialize.sh` script, optionally specifying the provider:

   ```bash
   bash initialize.sh [-gh|--github] [-ms|--microsoft]
   ```

3. Follow the output and login prompts to setup the tunnel with the selected provider
4. **UPDATE THE ACCOUNT DIRECTIVE** in `vscode_tunnel.sh` and submit via sbatch

   ```bash
   sbatch vscode_tunnel.sh
   ```

5. Open VScode on your local machine and connect to the tunnel using GitHub Authentication
6. Once finished, disconnect from the tunnel and cancel the job on the cluster using `scancel {JOB_ID}`

## Credit

This process was derived from Harvards FASRC "[VSCode Remote Development via SSH and Tunnel](https://docs.rc.fas.harvard.edu/kb/vscode-remote-development-via-ssh-or-tunnel/)"
