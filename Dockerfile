# R v 4 + python 3, Tensorflow, tidyverse, devtools, verse (tex and publishing related tools)
FROM rocker/ml-verse:4.0.2 

# environment variables
ENV SHINY_SERVER_VERSION 1.5.14.948
# add GITHUB_PAT due to rate limiting kicking in when installing packages
ARG GITHUB_PAT= 
ENV GITHUB_PAT=$GITHUB_PAT

WORKDIR /rocker_scripts

# install stock components from rocker_scripts
RUN ./install_shiny_server.sh && \
	./install_rstudio.sh

# extend existing rocker_scripts
COPY rocker_scripts/ .

# install extended set of packages	
RUN ./install_tini.sh && \
	./install_shinytools.sh && \
	./install_apitools.sh

# install R packages for biodiversity
RUN ./install_biodiversity.sh
RUN ./install_sbdi.sh

WORKDIR /

# Shiny server customization
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
COPY shiny-server.sh /usr/bin/shiny-server.sh
COPY rserver.conf /etc/rstudio/rserver.conf
COPY login.html /etc/rstudio/login.html

EXPOSE 8888
EXPOSE 3838

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]

# NB: if running with the shiny server, launch using this command: /usr/bin/shiny-server.sh
# NB: if running loadtest, launch using this command: "init"
