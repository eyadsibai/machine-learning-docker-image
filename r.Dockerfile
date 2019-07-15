FROM eyadsibai/docker-dsp:default


    # rstanrm

# RUN pip install git+https://github.com/jupyterhub/nbserverproxy.git
# RUN jupyter serverextension enable --sys-prefix --py nbserverproxy
# RUN pip install git+https://github.com/Viasat/nbrsessionproxy.git
# RUN jupyter serverextension enable --sys-prefix --py nbrsessionproxy
# RUN jupyter nbextension install    --sys-prefix --py nbrsessionproxy
# RUN jupyter nbextension enable     --sys-prefix --py nbrsessionproxy


# RUN git clone https://github.com/Viasat/nbrsessionproxy && cd nbrsessionproxy && jupyter labextension link jupyterlab-rsessionproxy


# ENV RLIB=$CONDA_DIR/lib/R/library

# COPY files/r_packages.R r_packages.R
# RUN Rscript r_packages.R && rm r_packages.R && rm -rf '/tmp/*'

## Set Renviron to get libs from base R install
# RUN echo "R_LIBS=\${R_LIBS-'/usr/local/lib/R/site-library:/usr/local/lib/R/library:/usr/lib/R/library'}" >> $CONDA_DIR/lib/R/etc/Renviron

# ## Set default CRAN repo
# RUN echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /usr/local/lib/R/etc/Rprofile.site
