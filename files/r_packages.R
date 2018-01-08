
install.packages('MLmetrics', '/opt/conda/lib/R/library', repos = 'http://cran.us.r-project.org')
install.packages('randomForestExplainer', '/opt/conda/lib/R/library', repos = 'http://cran.us.r-project.org')
install.packages('quanteda', '/opt/conda/lib/R/library', repos = 'http://cran.us.r-project.org')
install.packages('bnclassify', '/opt/conda/lib/R/library', repos = 'http://cran.us.r-project.org')
install.packages('bayesplot', '/opt/conda/lib/R/library', repos = 'http://cran.us.r-project.org')
install.packages('mice', '/opt/conda/lib/R/library', repos = 'http://cran.us.r-project.org')
install.packages('VIM', '/opt/conda/lib/R/library', repos = 'http://cran.us.r-project.org')
install.packages('lattice', '/opt/conda/lib/R/library', repos = 'http://cran.us.r-project.org')
install.packages('CausalImpact', '/opt/conda/lib/R/library', repos = 'http://cran.us.r-project.org')
library(devtools)
install_github('AppliedDataSciencePartners / xgboostExplainer', '/opt/conda/lib/R/library')
install_github("hadley/readr", '/opt/conda/lib/R/library')
install_github("jkrijthe/Rtsne", '/opt/conda/lib/R/library')
install_github("jennybc/gapminder", '/opt/conda/lib/R/library')
install_github("slowkow/ggrepel", '/opt/conda/lib/R/library')
install_github("hadley/ggplot2", '/opt/conda/lib/R/library')    # ggthemes is built against the latest ggplot2
install_github("jrnold/ggthemes", '/opt/conda/lib/R/library')
install_github("thomasp85/ggforce", '/opt/conda/lib/R/library')
install_github("thomasp85/ggraph", '/opt/conda/lib/R/library')
install_github("dgrtwo/gganimate",'/opt/conda/lib/R/library')
install_github("BillPetti/baseballr", '/opt/conda/lib/R/library')
install_github("dahtah/imager", '/opt/conda/lib/R/library')
install_github("elbamos/largevis", ref="develop", lib='/opt/conda/lib/R/library')  # Using development branch for now, see https://github.com/elbamos/largeVis/issues/40
install_github("dgrtwo/widyr", lib='/opt/conda/lib/R/library')
install_github("ellisp/forecastxgb-r-package/pkg", lib='/opt/conda/lib/R/library')
install_github("rstudio/leaflet", lib='/opt/conda/lib/R/library')
install_github("Microsoft/LightGBM", subdir = "R-package", lib='/opt/conda/lib/R/library')
install_github("hrbrmstr/hrbrthemes", lib='/opt/conda/lib/R/library')
install_github('catboost/catboost', subdir = 'catboost/R-package', lib='/opt/conda/lib/R/library')
install.packages("genderdata", repos = "http://packages.ropensci.org", lib='/opt/conda/lib/R/library')
install.packages("openNLPmodels.en",
                 repos = "http://datacube.wu.ac.at/",
                 type = "source",
                 lib = '/opt/conda/lib/R/library')

devtools::install_github("ropensci/monkeylearn")
install.packages("mindr")
devtools::install_github("mjskay/tidybayes")
install.packages("bmlm")
install.packages("vdiffr")
install_github('arcdiagram',  username='gastonstat')
install.packages("circlize")
devtools::install_github("tidyverse/glue")
install.packages("brms")
install.packages('caretEnsemble')
install.packages("stringr")
install.packages("tidyverse")
install.packages('ggfortify')
install.packages('forecast', dependencies = TRUE)
install.packages("tidyverse")
install.packages('caret')
devtools::install_github("mlr-org/mlr")
devtools::install_github("twitter/AnomalyDetection")
install.packages("bayesplot")
install.packages('daff')
install.packages("visdat")
install.packages("timetk")
install.packages("SuperLearner")
devtools::install_github("ropensci/iheatmapr")
    install.packages("ghit")
install.packages("corrplot")
install.packages("GGally")
install.packages("sjPlot")
devtools::install_github("tdhock/animint", upgrade_dependencies=FALSE)
install.packages('extrafont')
install.packages("greta")

devtools::install_github("hohenstein/remef")

clValid
# install_github("davpinto/fastknn", '/opt/conda/lib/R/library')
# install_github("mukul13/rword2vec", '/opt/conda/lib/R/library')

# #Packages for Neurohacking in R coursera course
# install.packages("oro.nifti")
# install.packages("oro.dicom")
# devtools::install_github("muschellij2/fslr")
# devtools::install_github("stnava/ITKR")
# install_github("stnava/ANTsRCore")
# devtools::install_github("stnava/ANTsR")
# devtools::install_github("muschellij2/extrantsr")

# install.packages("h2o", type="source", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/latest_stable_R"))) # install the latest stable version of h2o

# An upgrade to BH broke rstan, which in turn broke prophet. https://github.com/stan-dev/rstan/issues/441
# install_version("BH", version="1.62.0-1")
# install.packages("rstan")
# install.packages("prophet", lib='/opt/conda/lib/R/library')

# These signal processing libraries are on CRAN, but they require apt-get dependences that are
# handled in this image's Dockerfile.
# install.packages("fftw", '/opt/conda/lib/R/library')
# install.packages("seewave", '/opt/conda/lib/R/library')
install.packages("infer")
