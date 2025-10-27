# Machine Learning/Data Science Platform (Docker Image)

A comprehensive, unified Docker-based machine learning and data science platform with multiple conda environments for different use cases. Built on `python:3.8-slim` for minimal image size.

## Architecture

This Docker image contains **multiple conda environments** in a single unified image:

- **base**: Jupyter Lab/Notebook and common tools
- **ml-cpu**: CPU-optimized machine learning (scikit-learn, XGBoost, pandas, etc.)
- **ml-gpu**: GPU-accelerated deep learning (TensorFlow, PyTorch, Keras with CUDA support)
- **r-stats**: R programming language with statistical packages

All environments are available as Jupyter kernels - simply select the kernel when creating a new notebook!

## Key Features

### Base Environment
- **Jupyter Lab/Notebook**: Interactive development environment
- **Python 3.8**: Modern, stable Python version
- **Common Tools**: git, vim, wget, curl

### ML-CPU Environment
- **Data Analysis**: pandas 1.1.0+, numpy 1.19.0+, scipy 1.5.0+
- **Machine Learning**: scikit-learn 0.23.0+, XGBoost 1.0.0+, LightGBM 3.0.0+, CatBoost
- **NLP**: NLTK, spaCy, gensim
- **Visualization**: matplotlib, seaborn, bokeh, holoviews, plotly
- **Distributed Computing**: Dask
- **Feature Engineering**: featuretools, category_encoders
- **Model Interpretation**: SHAP, LIME, ELI5

### ML-GPU Environment  
- **Deep Learning**: TensorFlow 2.4.0+, PyTorch 1.7.0+, Keras 2.4.0+
- **Computer Vision**: torchvision, OpenCV
- **Reinforcement Learning**: OpenAI Gym, DeepMind control suite
- **Model Tools**: pytorch-ignite, tensorboard
- All ML-CPU packages plus GPU-accelerated versions

### R-Stats Environment
- **R Base**: Latest R language
- **R Essentials**: tidyverse, ggplot2, dplyr, etc.
- **Integration**: rpy2 for Python-R interoperability
- **Jupyter Kernel**: Use R directly in Jupyter notebooks

## Requirements

- Docker
- Docker Compose (recommended)
- NVIDIA Docker runtime (optional, for GPU support)

## How to use (on Google Cloud)

### Create VM instance

```bash
docker-machine create docker-dsp -d google \
  --google-project={project_id} \
  --google-machine-type n1-highmem-8 \
  --google-disk-size "10" \
  --google-disk-type "pd-standard" \
  --google-preemptible \
  --google-machine-image ubuntu-os-cloud/global/images/family/ubuntu-1804-lts \
  --google-scopes "https://www.googleapis.com/auth/cloud-platform"
```

### Configure Docker client


```bash
eval $(docker-machine env docker-dsp)
```

### Start Jupyter Lab


```bash
docker run -d -p 8888:8888 \
  -e "PROJECT_ID={project_id}" \
  eyadsibai/ml-unified:latest
```

### Get IP address

```bash
docker-machine ip docker-dsp
```

Open http://{docker-machine-ip}:8888 in your browser.

### Manage the instance

Stop the machine:

```bash
docker-machine stop docker-dsp
```

Start the machine:

```bash
docker-machine start docker-dsp
```

Delete the instance:

```bash
docker-machine rm docker-dsp
```

### Cost Note

When you stop the machine, it would cost you nothing except for the disk storage. For Google Cloud, 10GB of disk costs approximately $0.40/month.

## Image Size and Performance

**Optimizations:**
- Base image: `python:3.8-slim` (~500MB smaller than Ubuntu-based images)
- Multi-environment architecture: Share common dependencies across environments
- Efficient layering: Minimize redundancy between environments
- Clean conda cache after installations

**Approximate Image Sizes:**
- Base layers: ~1.5GB
- With ml-cpu environment: ~3.5GB  
- With ml-gpu environment: ~5.5GB
- Full image (all environments): ~6.5GB

This is significantly smaller than having 3 separate images (~15GB total).

## Environment Management

### List Available Environments

```bash
conda env list
```

### Install Additional Packages

```bash
# In a running container
conda activate ml-cpu
conda install package-name

# Or using pip
pip install package-name
```

### Export Environment

```bash
conda activate ml-cpu
conda env export > my-environment.yml
```
## Quick Start (with Docker Compose)

The easiest way to get started:

```bash
# Clone the repository
git clone https://github.com/eyadsibai/machine-learning-docker-image.git
cd machine-learning-docker-image

# Create work directory for your projects
mkdir work

# Start the container
docker-compose up -d

# Access Jupyter Lab
# Open http://localhost:8888 in your browser
```

**Selecting Environments:**
- In Jupyter Lab, click "New Launcher" or create a new notebook
- Choose your kernel:
  - **Python 3.8 (ML-CPU)**: For general ML tasks, data analysis
  - **Python 3.8 (ML-GPU)**: For deep learning with GPU acceleration
  - **R (Stats)**: For R-based statistical analysis

## How to Use (Locally)

## How to Use (Locally)

### Using Docker Run

```bash
docker run -d -p 8888:8888 \
  -v $(pwd)/work:/home/jovyan/work \
  eyadsibai/ml-unified:latest
```

Access Jupyter Lab at http://localhost:8888

### Switching Environments from Command Line

```bash
# Enter the container
docker exec -it <container-id> /bin/bash

# Activate ml-cpu environment
conda activate ml-cpu

# Activate ml-gpu environment  
conda activate ml-gpu

# Activate r-stats environment
conda activate r-stats

# List all environments
conda env list
```

### Using with GPU

For GPU support, ensure you have NVIDIA Docker runtime installed:

```bash
docker run -d -p 8888:8888 \
  --gpus all \
  -v $(pwd)/work:/home/jovyan/work \
  eyadsibai/ml-unified:latest
```

Or use docker-compose (uncomment the GPU section in docker-compose.yml).

## Included Tools & Libraries

### Core
- Python 3.6+
- Jupyter Notebook/Lab

### Data Analysis & Manipulation
- pandas
- numpy
- fastparquet

### Machine Learning
- scikit-learn
- XGBoost
- LightGBM
- Orange3
- Numba
- FastText
- Vowpal Wabbit
- libFM, libFFM, liblinear, libSVM

### Workflow & Orchestration
- Luigi
- Airflow

### NLP
- NLTK
- spaCy

### Network Analysis
- NetworkX

### Visualization
- matplotlib
- seaborn
- holoviews
- ggplot
- bokeh

### AWS Integration
- AWS packages and CLI tools

### Deep Learning (in `dl` image)
- TensorFlow
- PyTorch
- Keras

### Distributed Computing (in `dl` image)
- Apache Spark

## Building from Source

```bash
# Build default image
docker build -f default.Dockerfile -t eyadsibai/docker-dsp:default .

# Build deep learning image
docker build -f dl.Dockerfile -t eyadsibai/docker-dsp:dl .

# Build R image
docker build -f r.Dockerfile -t eyadsibai/docker-dsp:r .
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.
