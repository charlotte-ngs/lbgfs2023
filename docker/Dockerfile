FROM rocker/verse

LABEL maintainer="peter.vonrohr@usys.ethz.ch"

RUN R -e "install.packages(c('pedigreemm', 'kableExtra', 'AlphaSimR', dependencies = TRUE))" && \
    R -e "remotes::install_github(repo = 'charlotte-ngs/rmdhelp')" && \
    R -e "remotes::install_github(repo = 'pvrqualitasag/rvcetools')"
