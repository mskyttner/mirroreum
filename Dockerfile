# R v 4 + python 3, Tensorflow, tidyverse, devtools, verse (tex and publishing related tools)
FROM rocker/ml-verse:4.0.2 

# add GITHUB_PAT due to rate limiting kicking in when installing packages
ARG GITHUB_PAT= 
ENV GITHUB_PAT=$GITHUB_PAT

# Shiny server
ENV SHINY_SERVER_VERSION 1.5.14.948
RUN /rocker_scripts/install_shiny_server.sh

# RStudio
RUN /rocker_scripts/install_rstudio.sh

COPY rocker_scripts/install_ccache.sh /rocker_scripts/install_ccache.sh
COPY rocker_scripts/install_tini.sh /rocker_scripts/install_tini.sh
COPY rocker_scripts/install_shinytools.sh /rocker_scripts/install_shinytools.sh

# "tini" zombie reaper for containers
RUN /rocker_scripts/install_tini.sh

# Shiny tools for load testing etc
RUN /rocker_scripts/install_shinytools.sh

# R packages for biodiversity (general)
COPY rocker_scripts/install_biodiversity.sh /rocker_scripts/install_biodiversity.sh
RUN /rocker_scripts/install_biodiversity.sh

# R packages for biodiversity (general)
COPY rocker_scripts/install_sbdi.sh /rocker_scripts/install_sbdi.sh
RUN /rocker_scripts/install_sbdi.sh

# Shiny server customization
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
COPY shiny-server.sh /usr/bin/shiny-server.sh
COPY rserver.conf /etc/rstudio/rserver.conf
COPY login.html /etc/rstudio/login.html

# preinstall plumberish libs
COPY rocker_scripts/install_apitools.sh /rocker_scripts/install_apitools.sh
RUN /rocker_scripts/install_apitools.sh

RUN rm ~/.Renviron

EXPOSE 8888
EXPOSE 3838

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]

# NB: if running with the shiny server, launch using this command: /usr/bin/shiny-server.sh
# NB: if running loadtest, launch using this command: "init"
