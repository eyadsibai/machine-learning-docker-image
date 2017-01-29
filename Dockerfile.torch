FROM eyadsibai/docker-dsp:latest-python


RUN mkdir $HOME/bin
RUN git clone https://github.com/facebookresearch/fastText.git && cd fastText && make && mv fasttext $HOME/bin && cd .. \
&& rm -rf fastText

# Regularized Greedy Forests
RUN wget https://github.com/fukatani/rgf_python/releases/download/0.2.0/rgf1.2.zip && \
    unzip -q rgf1.2.zip && cd rgf1.2 && make && mv bin/rgf $HOME/bin && cd .. && rm -rf rgf*

# LightGBM
RUN git clone --recursive https://github.com/Microsoft/LightGBM && \
    cd LightGBM && mkdir build && cd build && cmake .. && make -j $(nproc) && \
        cd ../python-package && python setup.py install && cd ../.. && rm -rf LightGBM

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
