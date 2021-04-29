#!/bin/bash
set -e

# add libpoppler-cpp-dev needed by pdftools

apt-get update && apt-get install -y --no-install-recommends \
  libgtk2.0-dev \
  software-properties-common apt-file

apt-get install -y --no-install-recommends \
  libpoppler-cpp-dev

# R packages on CRAN

cat pkgs-cran | grep -v "#" | xargs install2.r --error --skipinstalled

# clean up
rm -rf /var/lib/apt/lists/*
