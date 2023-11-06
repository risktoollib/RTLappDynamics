FROM rocker/verse:4.3.2
RUN apt-get update && apt-get install -y  cmake libcurl4-openssl-dev libicu-dev libssl-dev libv8-dev libxml2-dev make pandoc zlib1g-dev && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /usr/local/lib/R/etc/ /usr/lib/R/etc/
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" | tee /usr/local/lib/R/etc/Rprofile.site | tee /usr/lib/R/etc/Rprofile.site
RUN R -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_version("testthat",upgrade="never", version = "3.2.0")'
RUN Rscript -e 'remotes::install_version("zoo",upgrade="never", version = "1.8-12")'
RUN Rscript -e 'remotes::install_version("lubridate",upgrade="never", version = "1.9.3")'
RUN Rscript -e 'remotes::install_version("dplyr",upgrade="never", version = "1.1.3")'
RUN Rscript -e 'remotes::install_version("bslib",upgrade="never", version = "0.5.1")'
RUN Rscript -e 'remotes::install_version("rmarkdown",upgrade="never", version = "2.25")'
RUN Rscript -e 'remotes::install_version("knitr",upgrade="never", version = "1.45")'
RUN Rscript -e 'remotes::install_version("scales",upgrade="never", version = "1.2.1")'
RUN Rscript -e 'remotes::install_version("tidyr",upgrade="never", version = "1.3.0")'
RUN Rscript -e 'remotes::install_version("readr",upgrade="never", version = "2.1.4")'
RUN Rscript -e 'remotes::install_version("plotly",upgrade="never", version = "4.10.3")'
RUN Rscript -e 'remotes::install_version("ggplot2",upgrade="never", version = "3.4.4")'
RUN Rscript -e 'remotes::install_version("tsibble",upgrade="never", version = "1.1.3")'
RUN Rscript -e 'remotes::install_version("shiny",upgrade="never", version = "1.7.5.1")'
RUN Rscript -e 'remotes::install_version("config",upgrade="never", version = "0.3.2")'
RUN Rscript -e 'remotes::install_version("fabletools",upgrade="never", version = "0.3.4")'
RUN Rscript -e 'remotes::install_version("spelling",upgrade="never", version = "2.2.1")'
RUN Rscript -e 'remotes::install_version("tibbletime",upgrade="never", version = "0.1.8")'
RUN Rscript -e 'remotes::install_version("rugarch",upgrade="never", version = "1.5-1")'
RUN Rscript -e 'remotes::install_version("RTL",upgrade="never", version = "1.3.5")'
RUN Rscript -e 'remotes::install_version("gt",upgrade="never", version = "0.10.0")'
RUN Rscript -e 'remotes::install_version("golem",upgrade="never", version = "0.4.1")'
RUN Rscript -e 'remotes::install_version("feasts",upgrade="never", version = "0.3.1")'
RUN Rscript -e 'remotes::install_version("corrr",upgrade="never", version = "0.4.4")'
RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone
RUN R -e 'remotes::install_local(upgrade="never")'
RUN rm -rf /build_zone
EXPOSE 80
CMD R -e "options('shiny.port'=80,shiny.host='0.0.0.0');library(RTLappDynamics);RTLappDynamics::run_app()"
