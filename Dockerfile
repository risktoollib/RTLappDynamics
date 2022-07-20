FROM risktoollib/rstudio:full
#FROM rocker/verse:4.2.0
RUN apt-get update && apt-get install git-core libcairo2-dev libcurl4-openssl-dev libgit2-dev libicu-dev libpng-dev libssl-dev libxml2-dev make pandoc pandoc-citeproc zlib1g-dev && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /usr/local/lib/R/etc/ /usr/lib/R/etc/
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" | tee /usr/local/lib/R/etc/Rprofile.site | tee /usr/lib/R/etc/Rprofile.site
RUN R -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_cran("rlang",upgrade="always", version = "1.0.4")'
RUN Rscript -e 'remotes::install_cran("processx",upgrade="always", version = "3.7.0")'
RUN Rscript -e 'remotes::install_cran("scales",upgrade="always", version = "1.2.0")'
RUN Rscript -e 'remotes::install_cran("zoo",upgrade="always", version = "1.8-10")'
RUN Rscript -e 'remotes::install_cran("ggplot2",upgrade="always", version = "3.3.6")'
RUN Rscript -e 'remotes::install_cran("lubridate",upgrade="always", version = "1.8.0")'
RUN Rscript -e 'remotes::install_cran("dplyr",upgrade="always", version = "1.0.9")'
RUN Rscript -e 'remotes::install_cran("tidyr",upgrade="always", version = "1.2.0")'
RUN Rscript -e 'remotes::install_cran("knitr",upgrade="always", version = "1.39")'
RUN Rscript -e 'remotes::install_cran("testthat",upgrade="always", version = "3.1.4")'
RUN Rscript -e 'remotes::install_cran("readr",upgrade="always", version = "2.1.2")'
RUN Rscript -e 'remotes::install_cran("plotly",upgrade="always", version = "4.10.0")'
RUN Rscript -e 'remotes::install_cran("bslib",upgrade="always", version = "0.4.0")'
RUN Rscript -e 'remotes::install_cran("tsibble",upgrade="always", version = "1.1.1")'
RUN Rscript -e 'remotes::install_cran("timetk",upgrade="always", version = "2.8.1")'
RUN Rscript -e 'remotes::install_cran("shiny",upgrade="always", version = "1.7.1")'
RUN Rscript -e 'remotes::install_cran("config",upgrade="always", version = "0.3.1")'
RUN Rscript -e 'remotes::install_cran("fabletools",upgrade="always", version = "0.3.2")'
RUN Rscript -e 'remotes::install_cran("covr",upgrade="always", version = "3.5.1")'
RUN Rscript -e 'remotes::install_cran("spelling",upgrade="always", version = "2.2")'
RUN Rscript -e 'remotes::install_cran("rmarkdown",upgrade="always", version = "2.14")'
RUN Rscript -e 'remotes::install_cran("tibbletime",upgrade="always", version = "0.1.6")'
RUN Rscript -e 'remotes::install_cran("thinkr",upgrade="always", version = "0.15")'
RUN Rscript -e 'remotes::install_cran("RTL",upgrade="always", version = "1.3.0")'
RUN Rscript -e 'remotes::install_cran("gt",upgrade="always", version = "0.6.0")'
RUN Rscript -e 'remotes::install_cran("golem",upgrade="always", version = "0.3.3")'
RUN Rscript -e 'remotes::install_cran("ggtext",upgrade="always", version = "0.1.1")'
RUN Rscript -e 'remotes::install_cran("feasts",upgrade="always", version = "0.2.2")'
RUN Rscript -e 'remotes::install_cran("corrr",upgrade="always", version = "0.4.3")'
#RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone
RUN R -e 'remotes::install_local(upgrade="always")'
RUN rm -rf /build_zone
EXPOSE 3838
CMD  ["R", "-e", "options('shiny.port'=3838,shiny.host='0.0.0.0');RTLappDynamics::run_app()"]
