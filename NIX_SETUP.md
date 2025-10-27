# Nix Setup Guide

This repository now uses Nix flakes for reproducible development environments. Nix provides deterministic, declarative environments without Docker containers.

## Prerequisites

### Install Nix

**Linux / macOS / WSL:**
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

**Enable Flakes:**
```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

Restart your terminal after installation.

## Quick Start

### 1. Enter Base Environment

```bash
nix develop
```

This provides Jupyter Lab and basic Python tools.

### 2. Enter ML-CPU Environment

For CPU-optimized machine learning with scikit-learn, pandas, XGBoost:

```bash
nix develop .#ml-cpu
```

### 3. Enter ML-GPU Environment

For GPU-accelerated deep learning with TensorFlow, PyTorch:

```bash
nix develop .#ml-gpu
```

**Note:** GPU support requires NVIDIA GPU and CUDA drivers installed on your system.

### 4. Enter R Statistics Environment

For R programming with tidyverse and statistical packages:

```bash
nix develop .#r-stats
```

## Starting Jupyter Lab

In any environment:

```bash
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser
```

Access at `http://localhost:8888`

## Available Environments

| Environment | Command | Description | Key Packages |
|------------|---------|-------------|--------------|
| **Base** | `nix develop` | Jupyter + basic Python | NumPy, Pandas, Matplotlib, Jupyter Lab |
| **ML-CPU** | `nix develop .#ml-cpu` | CPU-optimized ML | Scikit-learn, XGBoost, LightGBM, Statsmodels |
| **ML-GPU** | `nix develop .#ml-gpu` | GPU deep learning | TensorFlow 2.x, PyTorch 1.x, Keras, CUDA |
| **R-Stats** | `nix develop .#r-stats` | R statistics | tidyverse, caret, randomForest, IRkernel |

## Features

✅ **Reproducible** - Bit-for-bit identical environments across machines  
✅ **Declarative** - All dependencies defined in `flake.nix`  
✅ **Fast** - Binary cache means no compilation  
✅ **No Docker** - Native performance, no containerization overhead  
✅ **Multi-environment** - Easy switching between Python, R, GPU/CPU  
✅ **Version pinned** - Exact versions locked in `flake.lock`  

## Updating Dependencies

Update to latest package versions:

```bash
nix flake update
```

## Building Environments

Build the ML-CPU environment without entering it:

```bash
nix build .#ml-cpu
```

## Comparison: Nix vs Docker

| Feature | Nix | Docker (old) |
|---------|-----|--------------|
| **Size** | ~2-3GB | ~6.5GB |
| **Reproducibility** | Bit-for-bit | Layer-based |
| **Speed** | Native | Virtualized |
| **Learning curve** | Steeper | Gentler |
| **Disk space** | Shared `/nix/store` | Separate images |

## Troubleshooting

### "experimental-features" error

Add to `~/.config/nix/nix.conf`:
```
experimental-features = nix-command flakes
```

### CUDA not found (ml-gpu)

Ensure NVIDIA drivers are installed:
```bash
nvidia-smi  # Should show GPU info
```

### Package not found

Check if package is available in nixpkgs:
```bash
nix search nixpkgs python3Packages.scikit-learn
```

## Migration from Docker

The Nix setup replaces the Docker-based architecture:

**Docker (old):**
```bash
docker-compose up -d
```

**Nix (new):**
```bash
nix develop .#ml-cpu
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser
```

## Advanced Usage

### Custom packages

Edit `flake.nix` to add packages:

```nix
mlCpuEnv = pkgs.python3.withPackages (ps: with ps; [
  # ... existing packages ...
  your-package-here
]);
```

Then update:
```bash
nix flake lock --update-input nixpkgs
```

### direnv integration

Use `.envrc` for automatic environment activation:

```bash
echo "use flake" > .envrc
direnv allow
```

Now `cd` into the directory automatically activates the environment.

## Support

For Nix help:
- [Nix Manual](https://nixos.org/manual/nix/stable/)
- [Nix Package Search](https://search.nixos.org/)
- [nixpkgs issues](https://github.com/NixOS/nixpkgs/issues)

For this repository:
- Open an issue in this repo
