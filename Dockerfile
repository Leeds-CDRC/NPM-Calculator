FROM rocker/shiny-verse

RUN install2.r --error --deps TRUE shinyBS shinythemes shinyjs shinydashboard shinydashboardPlus shinyWidgets remotes

RUN R -e 'remotes::install_github("leeds-cdrc/nutrientprofiler@v0.2.1")'

COPY server.R /srv/shiny-server/server.R
COPY ui.R /srv/shiny-server/ui.R
COPY www /srv/shiny-server/www
COPY R /srv/shiny-server/R
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
