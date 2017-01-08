
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
     libboost-program-options-dev zlib1g-dev libboost-python-dev build-essential \
     && apt-get autoremove -y \
     && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g typescript

USER $NB_USER

ADD environment.yaml /tmp/environment.yaml
ADD install_pydatalab.sh /tmp/install_pydatalab.sh

# Install Python 3 packages
RUN conda config --set channel_priority false
RUN conda config --add channels conda-forge
RUN conda config --add channels glemaitre
RUN conda env update --file=/tmp/environment.yaml
RUN conda clean -i -l -t -y
RUN rm -rf $HOME/.cache/pip/*

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
    vader_lexicon verbnet webtext word2vec_sample wordnet wordnet_ic words ycoe

#installing pydatalab
RUN bash /tmp/install_pydatalab.sh

# Keras setup
# Keras likes to add a config file in a custom directory when it's
# first imported. This doesn't work with our read-only filesystem, so we
# have it done now
RUN python -c "from keras.models import Sequential"
# Switch to TF backend
RUN sed -i 's/theano/tensorflow/' $HOME/.keras/keras.json
# Re-run it to flush any more disk writes
RUN python -c "from keras.models import Sequential; from keras import backend; print(backend._BACKEND)"

# Activate ipywidgets extension in the environment that runs the notebook server
RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix
# Required to display Altair charts in Jupyter notebook
RUN jupyter nbextension install --py vega --sys-prefix
# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/g