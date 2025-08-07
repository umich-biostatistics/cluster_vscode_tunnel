# VScode Tunnel to Great Lakes Compute Node

This repo contains scripts that assist with creating a private LMOD module for the vscode cli tool and initializing a remote tunnel using GitHub or Microsoft authentication on a SLURM cluster.

## Scripts

- `initialize.sh` - Sets up the VSCode CLI tool and creates a private LMOD module
- `vscode_tunnel.sh` - SLURM batch script template for starting a VSCode tunnel
- `codetunnel` - Interactive helper script for submitting VSCode tunnel jobs with custom parameters

## Usage

> [!NOTE]
> The initialization script only needs to be run once to setup the module and authentication method for the tunnel.
> 
> Subsequent connections can be made by loading the module and using `codetunnel` or the `vscode_tunnel.sh` script.

### Option 1: Interactive Helper (Recommended)

Use the `codetunnel` helper script to interactively submit a SLURM job that sets up a VSCode tunnel on a compute node. The script validates your inputs, builds a temporary batch file, submits the job, and prints useful follow-up commands.

1. Copy or clone this repository onto the Great Lakes cluster:

   ```bash
   git clone https://github.com/umich-biostatistics/cluster_vscode_tunnel.git
   cd cluster_vscode_tunnel
   ```

2. Run the `initialize.sh` script to install the VSCode CLI and create a private LMOD module. You can choose GitHub or Microsoft authentication:

   ```bash
   bash initialize.sh [-gh|--github] [-ms|--microsoft]
   ```

3. After initialization, load the custom module and launch the interactive helper:

   ```bash
   ml use.own
   ml vscode
   codetunnel
   ```

4. You will be prompted for job parameters (press Enter to accept the default in brackets):

   - **Account (required)**: Your SLURM account name.
   - **Partition [debug]**: SLURM partition to use (e.g., `debug`, `standard`).
   - **Memory (GB) [14]**: Maximum memory in GB.
   - **CPUs per task [2]**: Number of CPU cores.
   - **GPUs (optional)**: Number of GPUs if required (e.g., `1`).
   - **Time limit [02:00:00]**: Job walltime in `HH:MM:SS` or `MM:SS` format.
   - **Job name [vscode_tunnel]**: A descriptive name for the job.
   - **Additional SBATCH options (optional)**: Any extra `#SBATCH` flags (e.g., `--mail-user=you@domain.com`).
   - **Additional modules (optional)**: Space-separated modules to load before running the tunnel (e.g., `cuda/11.2`).

5. Before submission, the script will print a summary of your settings. Confirm with **Y** to proceed or **n** to cancel.

6. On submission, you will see output similar to:

   ```text
   [INFO] Submitting job...
   [SUCCESS] Job submitted successfully with ID: 123456
   [INFO] Job details:
     Job ID: 123456
     Log file: /path/to/cluster_vscode_tunnel/logs/vscode_tunnel-123456.out

   [INFO] Useful commands:
     squeue -j 123456           # Check job status
     tail -f /path/to/…/logs/vscode_tunnel-123456.out  # View logs
     scancel 123456             # Cancel job
   ```

7. Once the job starts, open VScode on your local machine and connect to the tunnel using the authentication method chosen during the initialization step.

8. When you finish your work, disconnect from the tunnel in VSCode and cancel the job if it is still running:

   ```bash
   scancel 123456
   ```

#### Example Session

```bash
$ ml vscode
$ codetunnel
Account (required): myaccount
Partition [debug]: spgpu
Memory (GB) [14]: 32
CPUs per task [2]:
GPUs (optional): 1
Time limit (HH:MM:SS) [02:00:00]: 04:00:00
Job name [vscode_tunnel]: analysis_session
Additional SBATCH options (optional): --mail-type=END
Additional modules (optional): cuda/11.2

[INFO] Submitting job...
[SUCCESS] Job submitted successfully with ID: 789012
[INFO] Log file: …/logs/analysis_session-789012.out
```  

### Option 2: Manual Submission

Follow steps 1 & 2 as described in Option 1.

1. **UPDATE THE ACCOUNT DIRECTIVE** and any allocation directives in `vscode_tunnel.sh` and submit via sbatch

   ```bash
   sbatch vscode_tunnel.sh
   ```

2. Open VScode on your local machine and connect to the tunnel using the authentication method chosen during the initialization step.

3. Once finished, disconnect from the tunnel and cancel the job on the cluster using `scancel {JOB_ID}`

## Features

- **Interactive job submission** with parameter validation
- **Colored output** for better user experience
- **Automatic log directory creation**
- **Job status monitoring commands** provided after submission
- **Flexible authentication** support (GitHub or Microsoft)
- **Custom job parameters** without editing batch scripts

## Credit

This process was derived from Harvard's FASRC "[VSCode Remote Development via SSH and Tunnel](https://docs.rc.fas.harvard.edu/kb/vscode-remote-development-via-ssh-or-tunnel/)"
