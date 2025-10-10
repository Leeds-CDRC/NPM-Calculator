# Use a lighter base image - rocker/r-ver is smaller than shiny-verse
FROM rocker/r-ver:4.5.1

# Install system dependencies for Shiny
RUN apt-get update && apt-get install -y \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    pandoc \
    wget \
    gdebi-core \
    && rm -rf /var/lib/apt/lists/*

# Install only necessary R packages to reduce image size
RUN R -e "install.packages(c('shiny', 'dplyr', 'shinyBS', 'shinythemes', 'shinyjs', 'shinydashboard', 'shinydashboardPlus', 'shinyWidgets', 'remotes', 'ggplot2', 'DT', 'fresh', 'readxl'), repos='https://cran.rstudio.com/', dependencies=TRUE)" \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# Install shiny-server
RUN wget --no-verbose https://download3.rstudio.org/ubuntu-18.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt) && \
    wget --no-verbose "https://download3.rstudio.org/ubuntu-18.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb

# Install nutrientprofiler package
RUN R -e 'remotes::install_github("leeds-cdrc/nutrientprofiler@v2.0.0")' \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# Copy application files
COPY server.R /srv/shiny-server/server.R
COPY ui.R /srv/shiny-server/ui.R
COPY www /srv/shiny-server/www
COPY R /srv/shiny-server/R

# Create shiny-server configuration with memory settings
RUN echo 'run_as shiny;' > /etc/shiny-server/shiny-server.conf && \
    echo 'server {' >> /etc/shiny-server/shiny-server.conf && \
    echo '  listen 3838;' >> /etc/shiny-server/shiny-server.conf && \
    echo '  location / {' >> /etc/shiny-server/shiny-server.conf && \
    echo '    site_dir /srv/shiny-server;' >> /etc/shiny-server/shiny-server.conf && \
    echo '    log_dir /var/log/shiny-server;' >> /etc/shiny-server/shiny-server.conf && \
    echo '    directory_index on;' >> /etc/shiny-server/shiny-server.conf && \
    echo '    app_init_timeout 60;' >> /etc/shiny-server/shiny-server.conf && \
    echo '    app_idle_timeout 300;' >> /etc/shiny-server/shiny-server.conf && \
    echo '  }' >> /etc/shiny-server/shiny-server.conf && \
    echo '}' >> /etc/shiny-server/shiny-server.conf

# Set proper permissions
RUN chown -R shiny:shiny /srv/shiny-server/

EXPOSE 3838

CMD ["/usr/bin/shiny-server"]
