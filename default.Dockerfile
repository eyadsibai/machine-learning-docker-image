FROM jupyter/all-spark-notebook:latest

USER root

RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update && apt-get -qq install -y --no-install-recommends git libav-tools cmake build-essential liblapacke-dev \
# needed by vowpal wabbit
libboost-program-options-dev zlib1g-dev libboost-all-dev \
# needed by libhunspell
# libhunspell-dev \
&& apt-get -qq autoremove -y && apt-get -qq clean \
    && rm -rf /var/lib/apt/lists/*

USER $NB_USER
RUN conda config --set channel_priority false
COPY files/environment.default.yaml environment.yaml
RUN conda env update --file=environment.yaml \
    && conda remove qt pyqt --quiet --yes --force \
    && conda clean -tipsy && rm -rf "$HOME/.cache/pip/*" && rm environment.yaml && npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging

# Activate ipywidgets extension in the environment that runs the notebook server
# Required to display Altair charts in Jupyter notebook
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension && \
    jupyter nbextension enable --py --sys-prefix qgrid && \
    jupyter labextension install qgrid@1.0.0


#RUN jupyter labextension install @jupyterlab/google-drive
# RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
# RUN jupyter labextension enable @jupyter-widgets/jupyterlab-manager
# RUN jupyter labextension install @jupyterlab/github
# RUN jupyter labextension install jupyterlab_bokeh


# Configure ipython kernel to use matplotlib inline backend by default
RUN mkdir -p $HOME/.ipython/profile_default/startup
COPY files/mplimportnotebook.py $HOME/.ipython/profile_default/startup/

RUN mkdir -p $HOME/.config/matplotlib && echo 'backend: agg' > $HOME/.config/matplotlib/matplotlibrc
COPY files/ipython_config.py $HOME/.ipython/profile_default/ipython_config.py

ENV PATH $HOME/bin:$PATH

RUN mkdir $HOME/bin


# install fasttext -- now available thru conda
#  RUN git clone --depth 1 https://github.com/facebookresearch/fastText.git && \
#      cd fastText \
#      # && make && mv fasttext $HOME/bin  \
#      && pip install . && cd .. \
#      && rm -rf fastText


# Regularized Greedy Forests
RUN wget https://github.com/fukatani/rgf_python/releases/download/0.2.0/rgf1.2.zip && \
    unzip -q rgf1.2.zip && \
    cd rgf1.2 && \
    make && \
    mv bin/rgf $HOME/bin && \
    cd .. && \
    rm -rf rgf*

# FTRL
RUN git clone https://github.com/alexeygrigorev/libftrl-python && cd libftrl-python && cmake . && make && \
    mv libftrl.so ftrl/ && pip install . && cd .. && rm -rf libftrl-python

# Vowpal wabbit
RUN git clone --depth 1 https://github.com/JohnLangford/vowpal_wabbit.git && \
    cd vowpal_wabbit && \
    make vw && \
    make spanning_tree && \
    cp vowpalwabbit/vw $HOME/bin/ && \
    cp vowpalwabbit/active_interactor $HOME/bin/ && \
    cp cluster/spanning_tree $HOME/bin/ && \
    cd .. && rm -rf vowpal_wabbit

# # libfm
RUN git clone --depth 1 https://github.com/srendle/libfm.git && cd libfm && make all && \
    mv bin/* $HOME/bin/ && cd .. && rm -rf libfm

# # fast_rgf
RUN git clone --depth 1 https://github.com/baidu/fast_rgf.git && cd fast_rgf && \
    sed -i '10 s/^##*//' CMakeLists.txt && \
    cd build && cmake .. && make && make install && cd .. && mv bin/* $HOME/bin && \
    cd .. && rm -rf fast_rgf



USER $NB_USER

# RUN git clone --depth 1 https://github.com/PAIR-code/facets.git && cd facets && jupyter nbextension install facets-dist/ --sys-prefix
# ENV PYTHONPATH $HOME/facets/facets_overview/python/:$PYTHONPATH
RUN git clone --depth 1 https://github.com/guestwalk/libffm.git && cd libffm && make && cp ffm-predict $HOME/bin/ && cp ffm-train $HOME/bin/ && cd .. && rm -rf libffm

# RUN git clone https://github.com/alno/batch-learn.git && cd batch-learn && mkdir build && cd build && cmake .. && make  && cp batch-learn $HOME/bin/ && cd ../.. && rm -rf batch-learn

RUN git clone --depth 1 https://github.com/jeroenjanssens/data-science-at-the-command-line.git && mv data-science-at-the-command-line/tools/* $HOME/bin/ && \
rm -rf data-science-at-the-command-line

# NLP DATA
# RUN python -m nltk.downloader all \
#     && find $HOME/nltk_data -type f -name "*.zip" -delete
# RUN python -m spacy download en
# RUN python -m textblob.download_corpora

RUN ipython -c 'import disp; disp.install()'


# R
RUN R -e "install.packages('CausalImpact', '$CONDA_DIR/lib/R/library', repos = 'http://cran.us.r-project.org')"

# Rstudio Server
ENV RSTUDIO_WHICH_R='$CONDA_DIR/bin/R'
USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget \
    && rstudio_version=$(wget --no-check-certificate -qO- https://s3.amazonaws.com/rstudio-server/current.ver) \
    && wget https://download2.rstudio.org/rstudio-server-${rstudio_version}-amd64.deb -O /rstudio-server.deb \
    && apt-get install -y --no-install-recommends /rstudio-server.deb \
    && rm /rstudio-server.deb

RUN echo "rsession-which-r=$CONDA_DIR/bin/R" >> /etc/rstudio/rserver.conf


# Julia dependencies
# install Julia packages in /opt/julia instead of $HOME
ENV JULIA_PKGDIR=/opt/julia
ENV JULIA_VERSION=0.6.2

RUN mkdir /opt/julia-${JULIA_VERSION} && \
    cd /tmp && \
    wget -q https://julialang-s3.julialang.org/bin/linux/x64/`echo ${JULIA_VERSION} | cut -d. -f 1,2`/julia-${JULIA_VERSION}-linux-x86_64.tar.gz && \
    echo "dc6ec0b13551ce78083a5849268b20684421d46a7ec46b17ec1fab88a5078580 *julia-${JULIA_VERSION}-linux-x86_64.tar.gz" | sha256sum -c - && \
    tar xzf julia-${JULIA_VERSION}-linux-x86_64.tar.gz -C /opt/julia-${JULIA_VERSION} --strip-components=1 && \
    rm /tmp/julia-${JULIA_VERSION}-linux-x86_64.tar.gz
RUN ln -fs /opt/julia-*/bin/julia /usr/local/bin/julia


# Show Julia where conda libraries are \
RUN mkdir /etc/julia && \
    echo "push!(Libdl.DL_LOAD_PATH, \"$CONDA_DIR/lib\")" >> /etc/julia/juliarc.jl && \
    # Create JULIA_PKGDIR \
    mkdir $JULIA_PKGDIR && \
    chown $NB_USER $JULIA_PKGDIR && \
    fix-permissions $JULIA_PKGDIR


USER $NB_USER
# Add Julia packages
# Install IJulia as jovyan and then move the kernelspec out
# to the system share location. Avoids problems with runtime UID change not
# taking effect properly on the .local folder in the jovyan home dir.
RUN julia -e 'Pkg.init()' && \
    julia -e 'Pkg.update()' && \
#    julia -e 'Pkg.add("HDF5")' && \
    julia -e 'Pkg.add("Gadfly")' && \
    julia -e 'Pkg.add("RDatasets")' && \
    julia -e 'Pkg.add("IJulia")' && \
    # Precompile Julia packages \
#    julia -e 'using HDF5' && \
    julia -e 'using Gadfly' && \
    julia -e 'using RDatasets' && \
    julia -e 'using IJulia'
#COPY files/julia_packages.jl julia_packages.jl

#RUN julia julia_packages.jl && \
    # move kernelspec out of home \
RUN mv $HOME/.local/share/jupyter/kernels/julia* $CONDA_DIR/share/jupyter/kernels/ && \
    chmod -R go+rx $CONDA_DIR/share/jupyter && \
    rm -rf $HOME/.local && \
    fix-permissions $JULIA_PKGDIR $CONDA_DIR/share/jupyter

RUN npm i -g catboost-viewer && npm cache clean --force



# tensorflow board
EXPOSE 6006
# rstudio-server
EXPOSE 8787

RUN wget https://downloads.dataiku.com/public/studio/4.1.3/dataiku-dss-4.1.3.tar.gz && \
    tar xzf dataiku-dss-4.1.3.tar.gz && \
    dataiku-dss-4.1.3/installer.sh -d $HOME -p 11000 -C



#CMD ["/usr/lib/rstudio-server/bin/rserver", "--server-daemonize=0", "--server-app-armor-enabled=0"]
