
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
     && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g typescript

USER $NB_USER

ADD environment.yaml /tmp/environment.yaml
ADD install_pydatalab.sh /tmp/install_pydatalab.sh

#installing pydatalab
RUN bash /tmp/install_pydatalab.sh

# Install Python 3 packages
RUN conda env update --file=/tmp/environment.yaml

# Activate ipywidgets extension in the environment that runs the notebook server
RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/g

USER $NB_USER