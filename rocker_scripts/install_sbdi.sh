#!/bin/bash
set -e

echo "GITHUB_PAT=$GITHUB_PAT" >> ~/.Renviron

apt-get update && apt-get install -y --no-install-recommends \
	libssh-dev

# packages used in SBDI

R -e 'remotes::install_github("antonellilab/outsider.base", dependencies=TRUE)'
R -e 'remotes::install_github("antonellilab/outsider", dependencies=TRUE)'
R -e 'remotes::install_github("hannesmuehleisen/MonetDBLite-R", dependencies=TRUE)'
R -e 'remotes::install_github("ropensci/restez", dependencies=TRUE)'
R -e 'remotes::install_github("ropensci/phylotaR", dependencies=TRUE)'
R -e 'remotes::install_github("antonellilab/gaius", dependencies=TRUE)'

