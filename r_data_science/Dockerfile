# syntax = docker/dockerfile:1.0-experimental # https://docs.docker.com/develop/develop-images/build_enhancements/
FROM rocker/r-ver:4.0.0-ubuntu18.04

# System Libraries
RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
  && apt-get install -y \
  file \
  gdal-bin \
  libcairo2-dev \
  libgdal-dev \
  libproj-dev \
  pandoc \
  pandoc-citeproc \
  zlib1g-dev \
  libssl-dev \
  openssh-client \
  curl \
  r-cran-cairo

# R Libraries
RUN R -e "install.packages(c('data.table', \
  'devtools', \
  'dplyr', \
  'ggplot2', \
  'ggmap', \
  'odbc', \
  'shiny', \
  'shinydashboard'))"

# ============ SQL SERVER ============

# https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server
# Install SQL Server odbc driver and headers:
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
  && ACCEPT_EULA=Y apt-get install -y \
  msodbcsql17 \
  unixodbc-dev

# ============ ROracle ============

RUN export DEBIAN_FRONTEND=noninteractive; apt-get install -y \
  alien \
  libaio1 \
  curl

# https://yum.oracle.com/repo/OracleLinux/OL7/oracle/instantclient/x86_64/index.html
ARG RPM_URL=https://yum.oracle.com/repo/OracleLinux/OL7/oracle/instantclient/x86_64/getPackage

# Download RPM packages:
ARG ORACLE_VERSION=18.3
ARG ORACLE_FULL_VERSION=18.3.0.0.0-3
RUN curl $RPM_URL/oracle-instantclient18.3-basic-$ORACLE_FULL_VERSION.x86_64.rpm --output oraclebasic.rpm && \
    curl $RPM_URL/oracle-instantclient18.3-devel-$ORACLE_FULL_VERSION.x86_64.rpm --output oracledev.rpm
# Convert and install packages:
RUN alien -i oraclebasic.rpm && \
    alien -i oracledev.rpm
# Remove package files:
RUN rm -rf *.rpm

# We need to set LD_LIBRARY_PATH for the install command below,
# as well as for running ROracle in R later:
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/lib/oracle/$ORACLE_VERSION/client64/lib/
RUN OCI_LIB=/usr/lib/oracle/$ORACLE_VERSION/client64/lib \
    OCI_INC=/usr/include/oracle/$ORACLE_VERSION/client64 \
    R -e 'install.packages("ROracle");'
