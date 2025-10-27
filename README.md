# Machine Learning/Data Science Platform (Docker Image)

A comprehensive Docker-based machine learning and data science platform built on Jupyter, with extensive support for popular ML/DS libraries and tools.

## Features

- **Base**: Jupyter Notebook/Lab with Python 3
- **Data Analysis**: pandas, numpy, scipy, fastparquet
- **Machine Learning**: scikit-learn, XGBoost, LightGBM, CatBoost
- **Deep Learning**: TensorFlow, PyTorch, Keras
- **NLP**: NLTK, spaCy, gensim
- **Visualization**: matplotlib, seaborn, bokeh, holoviews
- **Distributed Computing**: Dask, Apache Spark
- **Cloud Integration**: AWS tools and packages

## Requirements

- Docker
- Docker Compose (recommended)
- docker-machine (optional, for Google Cloud deployment)

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
  eyadsibai/docker-dsp \
  start.sh jupyter lab --NotebookApp.token=''
```

### Get IP address


```bash
docker-machine ip docker-dsp
```

Open http://{docker-machine-ip}:8888 in your browser.

### Manage the instance

Stop the machine:


Stop the machine:

```bash
docker-machine stop docker-dsp
```

Start the machine:

```bash
docker-machine start docker-dsp
```

Delete the instance:

Delete the instance:

```bash
docker-machine rm docker-dsp
```

### Cost Note

When you stop the machine, it would cost you nothing except for the disk storage. For Google Cloud, 10GB of disk costs approximately $0.40/month.


## Quick Start (with Docker Compose)

The easiest way to get started is using Docker Compose:

```bash
# Edit docker-compose.yml to set your local workspace path
# Then run:
docker-compose up -d
```

Access Jupyter at http://localhost:8891

## How to use (Locally)

```bash
docker run -d -p 8888:8888 \
  -v <local-path>:/home/jovyan/work \
  eyadsibai/docker-dsp \
  start.sh jupyter lab --NotebookApp.token=''
```

Access Jupyter at http://localhost:8888

## Available Docker Images

- `eyadsibai/docker-dsp:default` - Standard ML/DS image with scikit-learn, pandas, etc.
- `eyadsibai/docker-dsp:dl` - Deep learning image with TensorFlow, PyTorch, Spark
- `eyadsibai/docker-dsp:r` - R integration on top of default image

## Included Tools & Libraries
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
