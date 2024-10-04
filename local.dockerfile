# Pull the base R Shiny image
FROM rocker/shiny-verse

# Install R dependencies
RUN install2.r --error --deps TRUE shinyBS shinythemes shinyjs shinydashboard shinydashboardPlus shinyWidgets remotes

# Install the  nutrientprofiler R package
RUN R -e 'remotes::install_github("leeds-cdrc/nutrientprofiler@v1.0.0")'

# Copy the Shiny app code to the srv directory
COPY server.R /srv/shiny-server/server.R
COPY ui.R /srv/shiny-server/ui.R
COPY www /srv/shiny-server/www
COPY R /srv/shiny-server/R
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

# Run the app by default
CMD R -e "shiny::runApp('/srv/shiny-server/', host='0.0.0.0', port=3838)"

# Expose the application port to serve the webapp
EXPOSE 3838