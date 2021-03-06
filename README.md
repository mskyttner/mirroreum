
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mirroreum <img src="https://raw.githubusercontent.com/mskyttner/mirroreum/master/sbdi.png" align="right" />

`mirroreum` is a dockerized web enabled environment for reproducible
open research work.

It bundles various tools for analytical biodiversity workflows.

Connectivity has been set up to enable working with various data
sources, including those provided by SBDI.

To support data science work using R, the web-variant of the RStudio IDE
is included as well as a Shiny server. This means that it comes with a
curated and pre-installed set of various assorted packages (including
web-enabled RStudio with Shiny and rmarkdown support). Specific packages
to support workflows within biodiversity analytics are included, for
example general purpose packages from
[ROpenSci.org](https://ROpenSci.org) and specific packages from SBDI.

# Quick start

Running locally requires that you have support for running containers,
for example using [Docker Community
Edition](https://docs.docker.com/engine/install/). Depending on your
base operating system, installation procedures differ but are well
documented online.

Once you have `docker` installed, you can download and run `mirroreum`
locally using the following commands, provided you have `docker` and
`make` installed first:

``` bash
# starting from scratch
mkdir ~/repos
cd ~/repos
git clone git@github.com:mskyttner/mirroreum.git
cd mirroreum
make start-ide
```

This will download and start a container, representing an instance of
the `mskyttner/mirroreum` Docker Image.

The `make start-ide` will run the statements in the Makefile that starts
the web-based RStudio Web Open Source Edition.

Use credentials for user/login: `rstudio/mirroreum` when logging in.

Strictly speaking the `make` and `git` tools are not needed to launch
the container, but the Makefile contains a target called “`start-ide`”
which specifies some switches to the startup command, including the
password to use and the location of your local `.Renviron` file which
hold your database connection credentials.

The “`start-ide`” Makefile target wraps the following command, which you
can run directly if you prefer (without requiring `git` or `make`):

``` bash
docker run -d --name mywebide \
    --env ROOT=TRUE \
    --env USERID=$(id -u) \
    --env PASSWORD=mirroreum \
    --publish 8787:8787 \
    --volume $(pwd)/home:/home/rstudio \
    --volume $HOME/.Renviron:/home/rstudio/.Renviron \
    sbdi/mirroreum /init
```

Note that this command assumes several things:

-   you have a directory named `home` under your present working
    directory, representing your rstudio home directory (this will be
    the case if you have checked out the mirroreum github repo with
    `git@github.com:mskyttner/mirroreum.git` and then changed your
    present working directory into this folder)
-   you have your `.Renviron` file in your system home directory
-   the command `id -u` returns the user id on the system

NB: This command may need to be amended on systems where these
assumptions are not valid. If you get an intialization error that says
“Unable to connect to service”, please check the above assumptions and
modify the command to work for your system setup.

Having `git` and `make` available on your host system allows you to make
changes, re-build the system or extend it and contribute these changes
back to the GitHub repository, should you wish to do so.

# Usage

If you are a developer or system administrator, you might be interested
in downloading and running `mirroreum` locally but also in building it
from source, extending it or contributing your changes.

Once you have `docker` installed, to start `mirroreum` locally, link a
local volume (in this example, a `home` sub-folder under the current
working directory, `$(pwd)`) to the container, start it and point your
browser to it with these CLI commands:

``` bash
# start mirroreum services to run the RStudio Open Source Web Edition
# mount your .Renviron file with the environment variables into the container... 

docker run -d --name mywebide \
    --env ROOT=TRUE \
    --env USERID=$(id -u) \
    --env PASSWORD=mirroreum \
    --publish 8787:8787 \
    --volume $(pwd)/home:/home/rstudio \
    --volume ~/.Renviron:/home/rstudio/.Renviron \
    sbdi/mirroreum /init

# after a couple of seconds, use login rstudio:mirroreum
firefox http://localhost:8787 &
```

The first command will start the container in the background so you can
visit `http://localhost:8787` with your web browser and log in with
username:password as `rstudio:mirroreum`.

### Common configuration options:

Use a custom user named after your user on the host, and password
specified in the `PASSWORD` environmental variable, and give the user
root permissions (add to sudoers) and work on files in the \~/foo
working directory:

``` bash
docker run -d --name mywebide \
    -p 8787:8787 \
    -e ROOT=TRUE \
    -e USERID=$UID \
    -e USER=$USER \
    -e PASSWORD=yourpasswordhere \
    -v $(pwd)/foo:/home/$USER/foo \
    -w /home/$USER/foo \
    sbdi/mirroreum /init
```

Available options are documented in more detail
[here](https://github.com/rocker-org/rocker-versioned/blob/master/rstudio/README.md).

## Building from source

To build `mirroreum` locally from source, starting from scratch, use
something like this:

        # starting from scratch
        mkdir ~/repos
        cd ~/repos
        git clone git@github.com:mskyttner/mirroreum.git
        cd mirroreum
        make

        # if you want to time the build, use...
        time make

This takes around 10-20 minutes on a modern laptop (and also when the
GitHub Action runs).

Use `docker images | grep mirroreum` to inspect the resulting image.

## Non-interactive usage

The `mirroreum` platform can also be used for purposes other than
functioning as an IDE, such as running non-interactive services:

-   a *web application server* (for `shiny` based web applications etc)
-   an *API server* (for `plumber`-based REST APIs)
-   a *report server* (to render Rmarkdown-based content into HTML / PDF
    / Office document-oriented and other supported document formats)
-   a *CLI execution context* for automating tasks (syncing data /
    setting up data flows, scheduling jobs etc)

### Running web apps

TODO: document and provide Makefile target with example

To use the image as a Shiny server, you can override the startup command
to use `/usr/bin/shiny-server.sh`:

``` bash
docker run -d --name myshinyapp \
    -p 3838:3838 \
    sbdi/mirroreum /usr/bin/shiny-server.sh

firefox http://localhost:3838 &
```

This will launch the default Shiny app in the container (see the
Dockerfile for deployment details).

To deploy your own app you can expose a directory on the host with your
app to the container. For mapping the host directory use the option
`-v <host_dir>:<container_dir>`. The following command will use the
present working directory as the Shiny app directory.

``` bash
docker run -d --name myshinyapp \
    -p 3838:3838 \
    -v $(pwd)/:/srv/shiny-server/ \
    sbdi/mirroreum /usr/bin/shiny-server.sh

firefox http://localhost:3838 &
```

If you have a Shiny app in a subdirectory of your present working
directory named appdir, you can now use a web browser to access the app
by visiting <http://localhost:3838/appdir/>

### CLI with bash prompt

If you wish you can access the CLI if you wish on the running `mywebide`
container:

``` bash
docker exec -it mywebide bash
```

A CLI/shell/terminal is available also from within the IDE’s own UI.

You can list the full set of included R packages by executing a command
against the running container like so:

``` bash
docker exec -it mywebide \
    R --quiet -e "cat(rownames(installed.packages()))"
```

# Contributions

[![Get the GitHub CLI
Badge](https://img.shields.io/badge/CLI-GitHub%20CLI%20Friendly-blue.svg)](https://hub.github.com)

The [GitHub CLI tool](https://hub.github.com) can be used for
reproducible collaboration workflows when collaborating on this (or any
other) repo, for whatever reason - such as for convenience and
automation support or perhaps because someone is handing out CLI badges
and you want one ;).

Usage example while at the CLI, if you want to add a feature branch that
provides command line support for using this R package along with usage
examples:

    $ hub clone mskyttner/mirroreum
    $ cd mirroreum

    # create a topic branch
    $ git checkout -b add-new-feature

    # make changes and test locally ... then ...

    $ git commit -m "done with my new feature"

    # It's time to fork the repo!
    $ hub fork --remote-name=origin
    → (forking repo on GitHub...)
    → git remote add origin git@github.com:YOUR_USER/mirroreum.git

    # push the changes to your new remote
    $ git push origin add-new-feature

    # open a pull request for the topic branch you've just pushed
    $ hub pull-request
    → (opens a text editor for your pull request message)

## License

The platform is an AGPL3-licensed portable dockerized software stack
supporting reproducible research efforts and analytics within the
bibliometrics domain but it also support analytics workflows in other
domains. It is based fully on free and open source licensed software.

It can be used entirely through the web browser and/or at the CLI and it
can run locally or be deployed at a server in the cloud to support users
who do not want to or need to run locally or install the dependencies
(docker, make etc).
