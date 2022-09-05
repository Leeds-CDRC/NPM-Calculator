FROM rocker/shiny-verse

RUN install2.r --error --deps TRUE shinyBS shinythemes shinyjs shinydashboard shinydashboardPlus shinyWidgets

COPY server.R /srv/shiny-server/server.R
COPY ui.R /srv/shiny-server/ui.R
COPY www /srv/shiny-server/www