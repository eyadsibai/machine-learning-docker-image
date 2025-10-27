# Unified ML Docker Image with Multiple Conda Environments
# Base: python:3.8-slim for smaller image size
# Environments: base (common), ml-cpu, ml-gpu, r-stats

FROM python:3.8-slim

LABEL maintainer="Eyad Sibai"
LABEL description="Comprehensive ML/DS Docker image with multiple conda environments"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    NB_USER=jovyan \
    NB_UID=1000 \
    NB_GID=100 \
    HOME=/home/jovyan

ENV PATH=$CONDA_DIR/bin:$HOME/bin:$PATH

# Install system dependencies
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Build essentials
    git wget curl bzip2 ca-certificates \
    build-essential cmake \
    gcc g++ gfortran \
    # Libraries for scientific computing
    libopenblas-dev liblapack-dev liblapacke-dev \
    # Audio/Video processing
    ffmpeg sox libsox-dev libsox-fmt-all \
    libasound2-dev portaudio19-dev libjack-dev \
    # Boost libraries (for vowpal wabbit, etc.)
    libboost-all-dev libboost-program-options-dev \
    zlib1g-dev \
    # Additional libraries
    libssl-dev libzmq3-dev \
    libpng-dev libjpeg-dev libtiff5-dev \
    # GPU support libraries (lightweight, only used if GPU available)
    libgl1-mesa-dev libglu1-mesa-dev \
    # Utilities
    vim nano less \
    sudo locales \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

# Create user
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    mkdir -p $CONDA_DIR && \
    chown $NB_USER:$NB_GID $CONDA_DIR && \
    chmod g+w /etc/passwd && \
    echo "$NB_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$NB_USER && \
    chmod 0440 /etc/sudoers.d/$NB_USER

USER $NB_USER
WORKDIR $HOME

# Install Miniconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -u -p $CONDA_DIR && \
    rm ~/miniconda.sh && \
    $CONDA_DIR/bin/conda clean -tipsy && \
    echo ". $CONDA_DIR/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

# Configure conda
RUN conda config --system --set auto_update_conda false && \
    conda config --system --set show_channel_urls true && \
    conda config --system --set channel_priority flexible && \
    conda config --system --add channels conda-forge && \
    conda config --system --add channels defaults

# Update base conda
RUN conda install -y -n base conda && \
    conda update -y -n base conda && \
    conda clean -tipsy

# Install Jupyter and common tools in base environment
RUN conda install -y -n base \
    python=3.8 \
    jupyter \
    jupyterlab \
    notebook \
    ipython \
    ipywidgets \
    ipykernel \
    && conda clean -tipsy

# Create ml-cpu environment (CPU-only machine learning)
COPY files/environment.default.yaml /tmp/environment-ml-cpu.yaml
RUN conda env create -n ml-cpu -f /tmp/environment-ml-cpu.yaml && \
    conda clean -tipsy && \
    rm /tmp/environment-ml-cpu.yaml

# Create ml-gpu environment (GPU-accelerated deep learning)
COPY files/environment.dl.yaml /tmp/environment-ml-gpu.yaml
RUN conda env create -n ml-gpu -f /tmp/environment-ml-gpu.yaml && \
    conda clean -tipsy && \
    rm /tmp/environment-ml-gpu.yaml

# Create r-stats environment (R and statistics)
RUN conda create -y -n r-stats python=3.8 && \
    conda install -y -n r-stats \
    r-base \
    r-essentials \
    r-irkernel \
    rpy2 \
    && conda clean -tipsy

# Register all environments as Jupyter kernels
RUN $CONDA_DIR/envs/ml-cpu/bin/python -m ipykernel install --user --name ml-cpu --display-name "Python 3.8 (ML-CPU)" && \
    $CONDA_DIR/envs/ml-gpu/bin/python -m ipykernel install --user --name ml-gpu --display-name "Python 3.8 (ML-GPU)" && \
    $CONDA_DIR/envs/r-stats/bin/Rscript -e "IRkernel::installspec(name = 'r-stats', displayname = 'R (Stats)')"

# Configure IPython
RUN mkdir -p $HOME/.ipython/profile_default/startup
COPY files/mplimportnotebook.py $HOME/.ipython/profile_default/startup/
COPY files/ipython_config.py $HOME/.ipython/profile_default/ipython_config.py
RUN mkdir -p $HOME/.config/matplotlib && \
    echo 'backend: agg' > $HOME/.config/matplotlib/matplotlibrc

# Create bin directory for custom tools
RUN mkdir -p $HOME/bin

# Install additional command-line tools in base environment
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Tools often used in ML workflows
    graphviz \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER $NB_USER

# Install fasttext (not available via conda)
RUN git clone --depth 1 https://github.com/facebookresearch/fastText.git /tmp/fastText && \
    cd /tmp/fastText && \
    make && \
    mv fasttext $HOME/bin/ && \
    pip install . && \
    cd ~ && \
    rm -rf /tmp/fastText

# Install other compiled tools in ml-cpu environment
RUN . $CONDA_DIR/etc/profile.d/conda.sh && \
    conda activate ml-cpu && \
    # Regularized Greedy Forests
    wget https://github.com/fukatani/rgf_python/releases/download/0.2.0/rgf1.2.zip && \
    unzip -q rgf1.2.zip && \
    cd rgf1.2 && \
    make && \
    mv bin/rgf $HOME/bin/ && \
    cd ~ && \
    rm -rf rgf* && \
    # Vowpal Wabbit
    git clone --depth 1 https://github.com/JohnLangford/vowpal_wabbit.git /tmp/vowpal_wabbit && \
    cd /tmp/vowpal_wabbit && \
    make vw && \
    cp vowpalwabbit/vw $HOME/bin/ && \
    cd ~ && \
    rm -rf /tmp/vowpal_wabbit && \
    # libFM
    git clone --depth 1 https://github.com/srendle/libfm.git /tmp/libfm && \
    cd /tmp/libfm && \
    make all && \
    mv bin/* $HOME/bin/ && \
    cd ~ && \
    rm -rf /tmp/libfm && \
    # libFFM
    git clone --depth 1 https://github.com/guestwalk/libffm.git /tmp/libffm && \
    cd /tmp/libffm && \
    make && \
    cp ffm-predict $HOME/bin/ && \
    cp ffm-train $HOME/bin/ && \
    cd ~ && \
    rm -rf /tmp/libffm && \
    # libSVM
    git clone --depth 1 https://github.com/cjlin1/libsvm /tmp/libsvm && \
    cd /tmp/libsvm && \
    make && \
    mv svm-predict $HOME/bin/ && \
    mv svm-train $HOME/bin/ && \
    mv svm-scale $HOME/bin/ && \
    cd ~ && \
    rm -rf /tmp/libsvm && \
    # liblinear
    git clone --depth 1 https://github.com/cjlin1/liblinear /tmp/liblinear && \
    cd /tmp/liblinear && \
    make && \
    mv predict $HOME/bin/liblinear-predict && \
    mv train $HOME/bin/liblinear-train && \
    cd ~ && \
    rm -rf /tmp/liblinear && \
    conda deactivate

# Expose ports
EXPOSE 8888 6006 8787

# Set working directory
WORKDIR $HOME/work
RUN mkdir -p $HOME/work

# Default command - start JupyterLab with all kernels available
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
