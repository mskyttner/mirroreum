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

R -e 'remotes::install_github("biodiversitydata-se/SBDI4R", dependencies=TRUE)'
R -e 'remotes::install_github("Greensway/BIRDS", dependencies=TRUE)'
R -e 'remotes::install_github("azizka/sampbias", dependencies=TRUE)'
R -e 'remotes::install_github("azizka/speciesgeocodeR", dependencies=TRUE)'
R -e 'remotes::install_github("fschirr/VirSysMon", dependencies=TRUE)'

