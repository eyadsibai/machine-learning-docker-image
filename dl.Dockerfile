FROM jupyter/all-spark-notebook:latest

USER root

RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update && apt-get -qq install -y libprotobuf-dev libleveldb-dev libgl1-mesa-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler libarmadillo-dev \
        binutils-dev libleptonica-dev && \
apt-get -qq install -y --no-install-recommends git libav-tools cmake build-essential \
# needed for tessarct
automake libtool autoconf-archive autoconf automake libtool pkg-config libpng12-dev libjpeg8-dev libtiff5-dev zlib1g-dev libicu-dev libpango1.0-dev libcairo2-dev \
libopenblas-dev libopencv-dev zlib1g-dev libboost-all-dev unzip libssl-dev libzmq3-dev portaudio19-dev \
libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler \
fonts-dejavu gfortran gcc \
&& apt-get -qq autoremove -y && apt-get -qq clean \
    && rm -rf /var/lib/apt/lists/*

USER $NB_USER
RUN conda config --system --add channels conda-forge --add channels glemaitre --add channels distributions --add channels maciejkula --add channels datamicroscopes --add channels ioam --add channels r && conda config --set channel_priority false
COPY files/environment.yaml environment.yaml
RUN conda env update --file=environment.yaml --quiet \
    && conda remove qt pyqt --quiet --yes --force \
    && conda clean -l -tipsy && rm -rf "$HOME/.cache/pip/*" && rm environment.yaml

# && python -m jupyterdrive --mixed --user

# Configure ipython kernel to use matplotlib inline backend by default
RUN mkdir -p $HOME/.ipython/profile_default/startup
COPY files/mplimportnotebook.py $HOME/.ipython/profile_default/startup/

RUN mkdir -p $HOME/.config/matplotlib && echo 'backend: agg' > $HOME/.config/matplotlib/matplotlibrc
COPY files/ipython_config.py $HOME/.ipython/profile_default/ipython_config.py

# RUN python -m nltk.downloader all \
#     && find $HOME/nltk_data -type f -name "*.zip" -delete
#RUN python -m spacy download en
# RUN python -m textblob.download_corpora

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot"
#RUN jt -t onedork -T -N -vim -lineh 140 -tfs 11
ENV PATH $HOME/bin:$PATH

# tensorflow board
EXPOSE 6006
RUN mkdir $HOME/bin


# Install Torch7
# RUN git clone --depth 1 --recursive https://github.com/torch/distro.git ~/torch
# USER root
# RUN cd /home/$NB_USER/torch && bash install-deps && apt-get autoremove -y && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

# USER $NB_USER
# RUN cd /home/$NB_USER/torch && ./install.sh -b \
#     && export LUA_PATH='$HOME/.luarocks/share/lua/5.1/?.lua;$HOME/.luarocks/share/lua/5.1/?/init.lua;$HOME/torch/install/share/lua/5.1/?.lua;$HOME/torch/install/share/lua/5.1/?/init.lua;./?.lua;$HOME/torch/install/share/luajit-2.1.0-alpha/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua' \
#     && export LUA_CPATH='$HOME/.luarocks/lib/lua/5.1/?.so;$HOME/torch/install/lib/lua/5.1/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so' \
#     && export PATH=$HOME/torch/install/bin:$PATH \
#     && export LD_LIBRARY_PATH=$HOME/torch/install/lib:$LD_LIBRARY_PATH \
#     && export DYLD_LIBRARY_PATH=$HOME/torch/install/lib:$DYLD_LIBRARY_PATH \
#     # install torch-nn
#     && luarocks install nn \
#      && luarocks install visdom \
#     # install iTorch
#     && git clone --depth 1 https://github.com/facebook/iTorch.git && \
#     cd iTorch && \
#     luarocks make \
#     # clean up
#     && cd /home/$NB_USER/torch && ./clean.sh


#Install Caffe
#  RUN git clone --depth 1 https://github.com/BVLC/caffe.git ~/caffe && \
#      cd ~/caffe && \
#      cat python/requirements.txt | xargs -n1 pip install && \
#      mkdir build && cd build && \
#      cmake -DCPU_ONLY=1 -DOPENCV_VERSION=3 -DUSE_NCCL=1 -Dpython_version=3 .. && \
#      make -j"$(nproc)" all && \
#      make install

# # Set up Caffe environment variables
# ENV CAFFE_ROOT=~/caffe
# ENV PYCAFFE_ROOT=$CAFFE_ROOT/python
# ENV PYTHONPATH=$PYCAFFE_ROOT:$PYTHONPATH
# ENV PATH=$CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH

# RUN echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig


# RUN git clone --recursive https://github.com/caffe2/caffe2.git
# RUN cd caffe2 && mkdir build && cd build \
#     && cmake .. \
#     -DUSE_CUDA=OFF \
#     -DUSE_NNPACK=OFF \
#     -DUSE_ROCKSDB=OFF \
#     && make -j"$(nproc)" install \
#     && ldconfig \
#     && make clean \
#     && cd .. \
#     && rm -rf build

# ENV PYTHONPATH /usr/local:$PYTHONPATH
RUN ipython -c 'import disp; disp.install()'

# COPY files/xcessiv_config.py $HOME/.xcessiv/config.py


# RUN wget http://www.mlpack.org/files/mlpack-2.2.5.tar.gz && \
#     tar xzf mlpack-2.2.5.tar.gz && rm mlpack-2.2.5.tar.gz && \
#     cd mlpack-2.2.5 && mkdir build && cd build && \
#     cmake -D DEBUG=OFF -D PROFILE=OFF ../ && \
#     make && make install

# ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH


# RUN git clone https://github.com/tesseract-ocr/tesseract && cd tesseract && ./autogen.sh && \
#     ./configure --prefix=$HOME/local/ && make install

# ENV TESSDATA_PREFIX  $HOME/tessdata

# RUN mkdir tessdata && cd tessdata && \
#     wget https://github.com/tesseract-ocr/tessdata/raw/3.04.00/osd.traineddata && \
#     wget https://github.com/tesseract-ocr/tessdata/raw/3.04.00/equ.traineddata && \
#     wget https://github.com/tesseract-ocr/tessdata/raw/4.00/ara.traineddata && \
#     wget https://github.com/tesseract-ocr/tessdata/raw/4.00/eng.traineddata

#installed by python
# RUN git clone https://github.com/davisking/dlib && cd dlib && mkdir build && cd build && cmake .. && cmake --build . && cd .. && python setup.py install


# RUN mkdir corex && cd corex && \
#     wget https://raw.githubusercontent.com/gregversteeg/bio_corex/master/corex.py && \
#     wget https://raw.githubusercontent.com/gregversteeg/bio_corex/master/vis_corex.py && \
#     wget https://raw.githubusercontent.com/gregversteeg/corex_topic/master/corex_topic.py && \
#     wget https://raw.githubusercontent.com/gregversteeg/corex_topic/master/vis_topic.py

# RUN mkdir empca && cd empca && wget https://raw.githubusercontent.com/sbailey/empca/master/empca.py

# ENV PYTHONPATH $HOME/corex:$HOME/empca:${PYTHONPATH}

# ENV SPARK_OPTS --driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info --packages com.spotify:featran-core_2.11:0.1.9,com.spotify:featran-numpy_2.11:0.1.9
#com.airbnb.aerosolve:core:0.1.103 add bintray repo
#com.github.haifengl:smile-scala:1.4.0

#npm install -g ijavascript
#ijsinstall
#npm install deeplearn
#curl -fsS https://dlang.org/install.sh | bash -s ldc
#source ~/dlang/ldc-{VERSION}/activate

# RUN wget https://github.com/google/or-tools/releases/download/v6.4/or-tools_python_examples_v6.4.4495.zip -O ortools.zip && \
# unzip ortools.zip && cd ortools_examples && make install && cd .. && rm -rf ortools


EXPOSE 1994
# CMD ["xcessiv"]
