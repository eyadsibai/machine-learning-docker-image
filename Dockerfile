
FROM jupyter/minimal-notebook

MAINTAINER Eyad Sibai <eyad.alsibai@gmail.com>

USER root

ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update && apt-get install -y curl

RUN curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash -


# libav-tools for matplotlib anim
# nodejs for pydatalab
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
     libav-tools \
     git \
     nodejs \
     libboost-program-options-dev zlib1g-dev libboost-python-dev cmake build-essential \
     && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g typescript

USER $NB_USER

ADD environment.yaml /tmp/environment.yaml
ADD install_pydatalab.sh /tmp/install_pydatalab.sh

# Install Python 3 packages
RUN conda env update --file=/tmp/environment.yaml


#installing pydatalab
RUN bash /tmp/install_pydatalab.sh


# Install XGBoost library
RUN git clone --recursive https://github.com/dmlc/xgboost && \
    cd xgboost && \
    make -j4 && \
    cd python-package; python setup.py install

# Keras setup
# Keras likes to add a config file in a custom directory when it's
# first imported. This doesn't work with our read-only filesystem, so we
# have it done now
RUN python -c "from keras.models import Sequential"
# Switch to TF backend
RUN sed -i 's/theano/tensorflow/' /root/.keras/keras.json
# Re-run it to flush any more disk writes
RUN python -c "from keras.models import Sequential; from keras import backend; print(backend._BACKEND)"
# Keras reverts to /tmp from ~ when it detects a read-only file system
RUN mkdir -p /tmp/.keras && cp /root/.keras/keras.json /tmp/.keras

# Activate ipywidgets extension in the environment that runs the notebook server
RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix
# Required to display Altair charts in Jupyter notebook
RUN jupyter nbextension install --user --py vega --sys-prefix
# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/g

USER $NB_USER