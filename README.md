# NPM Calculator Tool

[![DOI](https://zenodo.org/badge/525283616.svg)](https://zenodo.org/badge/latestdoi/525283616)

Second release of the NPM Calculator tool. This version is designed to assess user-entered single product information against the [UK NPM (2004/5)](https://www.gov.uk/government/publications/the-nutrient-profiling-model) and scope for [HFSS legislation](https://www.gov.uk/government/publications/restricting-promotions-of-products-high-in-fat-sugar-or-salt-by-location-and-by-volume-price/restricting-promotions-of-products-high-in-fat-sugar-or-salt-by-location-and-by-volume-price-implementation-guidance) around product placement.

## NPM Table Calculator

This package also includes an experimental Table Calculator feature. 
This uses the CDRC R package
[`nutrientprofiler`](https://github.com/Leeds-CDRC/nutrientprofiler)
which is explicitly installed in the [Dockerfile](./Dockerfile). All components
of the Table Calculator except server functions are defined within new component
files that are present in the [`R`](./R/) folder. All server functions for the
Table Calculator are defined within [server.R](./server.R#L509) to enable proper
propogration of input and output variables.

### Updating `nutrientprofiler` package in NPM Calculator

Occasionally, there may be updates to the
[`nutrientprofiler`](https://github.com/Leeds-CDRC/nutrientprofiler) package
that need to be updated within this Shiny app. To pull through more up to date
versions of the package you should change the version specified within the `RUN`
line that installs the package within the [Dockerfile](./Dockerfile#L5).

```docker
# change @v1.0.0 to another version
RUN R -e 'remotes::install_github("leeds-cdrc/nutrientprofiler@v1.0.0")'
```

If the change is not included in a version but rather is the most recent commit
on the `main` branch, you can change `@v1.0.0` to `@main`, or remove the `@v1.0.0`
section completely.

## Building the app locally

Running an app locally is a useful way of testing changes and updates without affecting the live version of the webapp. In order to deploy this app locally in your web browser, you will need Docker (or a Linux macine) and a version of git installed (you can use plain [git](https://git-scm.com/), [GitHub CLI](https://cli.github.com/), or [GitHub Desktop](https://desktop.github.com/)).

### Deployment using a Docker container

After cloning the repository with git and navigating into the folder, from your command line/terminal as a Docker-enabled user (with Docker running):

```bash
# Build a container using the file "local.dockerfile"
# -t provides a tag to reference the container later
docker build -f local.dockerfile . -t npm-calculator
```

It will take a little while to build the docker image locally.

You can check that this has built locally with the command `docker images`, which should have output similar to this:

```bash
docker images

REPOSITORY       TAG       IMAGE ID       CREATED              SIZE
npm-calculator   latest    ID-code-here   About a minute ago   2.2GB
```

You can then run the docker image and forward the specified port from the container to the host machine you are working on, so that you can view it in a web browser:

```bash
docker run -p 3838:3838 npm-calculator
```

Now, visit http://localhost:3838/ to view the local application.

> This local deployment has been tested on Windows, WSL2, and Linux (Ubuntu 22.04).

### Deployment using a devcontainer

Alternatively, you can launch a [devcontainer](https://code.visualstudio.com/docs/devcontainers/containers) from VSCode by opening the folder in VSCode, launching the command pallette (`F1`) and selecting "Dev Container: Open folder in a container...".

It will take a few minutes for the container to build; once it has, you will be able to open a new terminal in VSCode within this contained environment. You can view your app by running the following from the terminal (within the devcontainer):

```bash
R -e "shiny::runApp(host='0.0.0.0', port=3838)"
```
Note that unlike the Docker container for deployment, the app files are not copied across to `/srv/shiny-server/` and the shiny app is launched from the main repository directory.

Alternatively, you can launch an interactive R session, and then run:

```R
shiny::runApp(host='0.0.0.0', port=3838)
```
### Deployment using a devcontainer on GitHub codespaces

You can launch the devcontainer using the cloud platform GitHub codespaces. Launching the project is possible from the repository main page on GitHub, from the "Code" tab (where you can copy the link to clone the repository). A sub-tab in the pop-up dialogue will prompt you to create a new codespace on main.

### Deployment on Linux in an environment

You can also deploy locally from a Linux machine (or WSL2 in Windows) where R and git are installed.

You can create an R env using the `renv` package, or you can build a virtual environment using conda or an alternative package manager.

If using conda/mamba, create your environment using the `conda-env.yml` file:

```bash
conda env create --file conda-env.yml
```

Then, you can activate this env (`conda activate npm-env`) and use the `remotes` package to install the `nutrientprofiler` package:

```bash
R -e 'remotes::install_github("leeds-cdrc/nutrientprofiler@v1.0.0")'
```
Note this only needs to be done the first time the environment is activated.

And then run the app from the project directory:

```bash
R -e "shiny::runApp(host='0.0.0.0', port=3838)"
```