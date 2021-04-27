#!/bin/bash
set -e

# add libpoppler-cpp-dev needed by pdftools

apt-get update && apt-get install -y --no-install-recommends \
  libgtk2.0-dev \
  software-properties-common apt-file

apt-get install -y --no-install-recommends \
  libpoppler-cpp-dev


# R packages on CRAN

# generic tooling/infra packages 
install2.r --error --skipinstalled \
	plumber \
	configr \
	shinydashboard \
	flexdashboard \
	auth0

# general visualization and analysis packages
install2.r --error --skipinstalled \
	tsibble \
	plotly \
	igraph \
	networkD3 \
	visNetwork \
	ggthemes \
	mapr \
	RColorBrewer \
	rworldmap \
	maps \
	CoordinateCleaner	

# specific packages
install2.r --error --skipinstalled \
	grDevices \
	outsider \
	sp \
	spdep \
	wiqid \
	raster \
	sf \
	ncf \
	rgbif \
	rredlist \
	taxize \
	swirl \
	ape \
	phangorn \
	seqinr
	
# clean up
rm -rf /var/lib/apt/lists/*
