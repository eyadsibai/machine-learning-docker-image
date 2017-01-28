FROM eyadsibai/docker-dsp:latest-torch

MAINTAINER Eyad Sibai <eyad.alsibai@gmail.com>

# Vowpal wabbit
git clone https://github.com/JohnLangford/vowpal_wabbit.git && \
cd vowpal_wabbit && \
make && \
make install

# MXNet
RUN git clone --recursive https://github.com/dmlc/mxnet && \
    cd mxnet && cp make/config.mk . && echo "USE_BLAS=openblas" >> config.mk && \
    make && cd python && python setup.py install && cd ../../ && rm -rf mxnet
