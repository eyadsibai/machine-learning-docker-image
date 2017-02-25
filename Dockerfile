FROM jupyter/base-notebook:latest

MAINTAINER Eyad Sibai <eyad.alsibai@gmail.com>

USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update && apt-get -qq install -y --no-install-recommends git libav-tools cmake build-essential \
libopenblas-dev libopencv-dev libboost-program-options-dev zlib1g-dev libboost-python-dev unzip libssl-dev libzmq3-dev \
&& apt-get -qq autoremove -y && apt-get -qq clean \
    && rm -rf /var/lib/apt/lists/*

USER $NB_USER
RUN conda config --add channels conda-forge --add channels glemaitre --add channels distributions --add channels datamicroscopes --add channels ioam && conda config --set channel_priority false
COPY files/environment.yaml environment.yaml
RUN conda env update --file=environment.yaml --quiet \
    && conda remove qt pyqt --quiet --yes --force \
    && conda clean -i -l -t -y && rm -rf "$HOME/.cache/pip/*" && rm environment.yaml

# install packages without their dependencies
RUN pip install rep git+https://github.com/googledatalab/pydatalab.git --no-deps \
&& rm -rf "$HOME/.cache/pip/*"

# Activate ipywidgets extension in the environment that runs the notebook server
# Required to display Altair charts in Jupyter notebook
RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix
# && python -m jupyterdrive --mixed --user

# Configure ipython kernel to use matplotlib inline backend by default
RUN mkdir -p $HOME/.ipython/profile_default/startup
COPY files/mplimportnotebook.py $HOME/.ipython/profile_default/startup/

RUN mkdir -p $HOME/.config/matplotlib && echo 'backend: agg' > $HOME/.config/matplotlib/matplotlibrc
COPY files/ipython_config.py $HOME/.ipython/profile_default/ipython_config.py

RUN python -m nltk.downloader abc alpino \
    averaged_perceptron_tagger basque_grammars biocreative_ppi bllip_wsj_no_aux \
    book_grammars brown brown_tei cess_cat cess_esp chat80 city_database cmudict \
    comparative_sentences comtrans conll2000 conll2002 conll2007 crubadan dependency_treebank \
    europarl_raw floresta gazetteers genesis gutenberg hmm_treebank_pos_tagger \
    ieer inaugural indian jeita kimmo knbc large_grammars lin_thesaurus mac_morpho machado \
    masc_tagged maxent_ne_chunker maxent_treebank_pos_tagger moses_sample movie_reviews \
    mte_teip5 names nps_chat omw opinion_lexicon paradigms \
    pil pl196x ppattach problem_reports product_reviews_1 product_reviews_2 propbank \
    pros_cons ptb punkt qc reuters rslp rte sample_grammars semcor sentence_polarity \
    sentiwordnet shakespeare sinica_treebank smultron snowball_data spanish_grammars \
    state_union stopwords subjectivity swadesh switchboard tagsets timit toolbox treebank \
    twitter_samples udhr2 udhr unicode_samples universal_tagset universal_treebanks_v20 \
    vader_lexicon verbnet webtext word2vec_sample wordnet wordnet_ic words ycoe \
    && find $HOME/nltk_data -type f -name "*.zip" -delete
RUN python -m spacy.en.download
RUN python -m textblob.download_corpora

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot"
RUN jt -t onedork -T -N -vim -lineh 140 -tfs 11
ENV PATH $HOME/bin:$PATH

# tensorflow board
EXPOSE 6006

# install fasttext
RUN mkdir $HOME/bin
RUN git clone https://github.com/facebookresearch/fastText.git && \
    cd fastText && make && mv fasttext $HOME/bin && cd .. \
    && rm -rf fastText

# Regularized Greedy Forests
RUN wget https://github.com/fukatani/rgf_python/releases/download/0.2.0/rgf1.2.zip && \
    unzip -q rgf1.2.zip && \
    cd rgf1.2 && \
    make && \
    mv bin/rgf $HOME/bin && \
    cd .. && \
    rm -rf rgf*

# LightGBM
RUN git clone --recursive https://github.com/Microsoft/LightGBM && \
    cd LightGBM && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j $(nproc) && \
    cd ../python-package && \
    python setup.py install && \
    cd ../.. && \
    rm -rf LightGBM

# Install Torch7
RUN git clone https://github.com/torch/distro.git ~/torch --recursive
USER root
RUN cd /home/$NB_USER/torch && bash install-deps && apt-get autoremove -y && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
USER $NB_USER
RUN cd /home/$NB_USER/torch && ./install.sh -b

# Export environment variables manually
ENV LUA_PATH='$HOME/.luarocks/share/lua/5.1/?.lua;$HOME/.luarocks/share/lua/5.1/?/init.lua;$HOME/torch/install/share/lua/5.1/?.lua;$HOME/torch/install/share/lua/5.1/?/init.lua;./?.lua;$HOME/torch/install/share/luajit-2.1.0-alpha/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua' \
    LUA_CPATH='$HOME/.luarocks/lib/lua/5.1/?.so;$HOME/torch/install/lib/lua/5.1/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so' \
    PATH=$HOME/torch/install/bin:$PATH \
    LD_LIBRARY_PATH=$HOME/torch/install/lib:$LD_LIBRARY_PATH \
    DYLD_LIBRARY_PATH=$HOME/torch/install/lib:$DYLD_LIBRARY_PATH

# install torch-nn
RUN luarocks install nn

# Install iTorch
RUN git clone https://github.com/facebook/iTorch.git && \
    cd iTorch && \
    luarocks make

# # Install Lasagne
# RUN pip --no-cache-dir install git+git://github.com/Lasagne/Lasagne.git@${LASAGNE_VERSION}



# # Install Theano and set up Theano config (.theanorc) OpenBLAS
# RUN pip --no-cache-dir install git+git://github.com/Theano/Theano.git@${THEANO_VERSION} && \
# 	\
# 	echo "[global]\ndevice=cpu\nfloatX=float32\nmode=FAST_RUN \
# 		\n[lib]\ncnmem=0.95 \
# 		\n[nvcc]\nfastmath=True \
# 		\n[blas]\nldflag = -L/usr/lib/openblas-base -lopenblas \
# 		\n[DebugMode]\ncheck_finite=1" \
# 	> /root/.theanorc

# Vowpal wabbit
#RUN git clone https://github.com/JohnLangford/vowpal_wabbit.git && \
#cd vowpal_wabbit && \
#make && \
#make install

# MXNet
RUN git clone --recursive https://github.com/dmlc/mxnet && \
    cd mxnet && cp make/config.mk . && echo "USE_BLAS=openblas" >> config.mk && \
    make && cd python && python setup.py install && cd ../../ && rm -rf mxnet

RUN python -c "from keras.applications.resnet50 import ResNet50; ResNet50(weights='imagenet')"
RUN python -c "from keras.applications.vgg16 import VGG16; VGG16(weights='imagenet')"
RUN python -c "from keras.applications.vgg19 import VGG19; VGG19(weights='imagenet')"
RUN python -c "from keras.applications.inception_v3 import InceptionV3; InceptionV3(weights='imagenet')"
RUN python -c "from keras.applications.xception import Xception; Xception(weights='imagenet')"


# Install Caffe
# RUN git clone -b ${CAFFE_VERSION} --depth 1 https://github.com/BVLC/caffe.git ~/caffe && \
#     cd ~/caffe && \
#     cat python/requirements.txt | xargs -n1 pip install && \
#     mkdir build && cd build && \
#     cmake -DCPU_ONLY=1 -DBLAS=Open .. && \
#     make -j"$(nproc)" all && \
#     make install
#
# # Set up Caffe environment variables
# ENV CAFFE_ROOT=~/caffe
# ENV PYCAFFE_ROOT=$CAFFE_ROOT/python
# ENV PYTHONPATH=$PYCAFFE_ROOT:$PYTHONPATH \
#     PATH=$CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH
#
# RUN echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig
