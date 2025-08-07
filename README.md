# VScode Tunnel to Great Lakes Compute Node

This repo contains scripts that assist with creating a private LMOD module for the vscode cli tool and initializing a remote tunnel using GitHub or Microsoft authentication on a SLURM cluster.

## Scripts

- `initialize.sh` - Sets up the VSCode CLI tool and creates a private LMOD module
- `vscode_tunnel.sh` - SLURM batch script template for starting a VSCode tunnel
- `codetunnel` - Interactive helper script for submitting VSCode tunnel jobs with custom parameters

## Usage

### Option 1: Interactive Helper (Recommended)

1. Copy/clone the scripts to Great Lakes
2. Run the `initialize.sh` script, optionally specifying the provider:

   ```bash
   bash initialize.sh [-gh|--github] [-ms|--microsoft]
   ```

3. Follow the output and login prompts to setup the tunnel with the selected provider
4. Load the vscode module and use the interactive helper:

   ```bash
   ml vscode
   codetunnel
   ```

5. The `codetunnel` script will prompt you for:
   - Account (required)
   - Partition (default: debug)
   - Memory in GB (default: 14)
   - CPUs per task (default: 2)
   - GPUs (optional)
   - Time limit (default: 02:00:00)
   - Job name (default: vscode_tunnel)
   - Additional SBATCH options (optional)

6. Open VSCode on your local machine and connect to the tunnel using the appropriate authentication
7. Once finished, disconnect from the tunnel and cancel the job using `scancel {JOB_ID}`

### Option 2: Manual Submission

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

## Features

- **Interactive job submission** with parameter validation
- **Colored output** for better user experience
- **Automatic log directory creation**
- **Job status monitoring commands** provided after submission
- **Flexible authentication** support (GitHub or Microsoft)
- **Custom job parameters** without editing batch scripts

## Credit

This process was derived from Harvard's FASRC "[VSCode Remote Development via SSH and Tunnel](https://docs.rc.fas.harvard.edu/kb/vscode-remote-development-via-ssh-or-tunnel/)"
