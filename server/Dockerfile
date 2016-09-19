# Base image
FROM ubuntu:14.04

LABEL phabricator=server

ARG DEBIAN_FRONTEND=noninteractive


# DEPENDENCIES
# ============

# Install `apt-get` packages
RUN apt-get update && apt-get install -qq -y \
  git \
  apache2 \
  php5 \
  php5-mysql \
  php5-apcu \
  php5-curl \
  php5-gd \
  python-pygments \
  mysql-client \
  apt-utils \
  && apt-get clean


# PREPARE PHABRICATOR CODE
# ========================

# Add phabricator projects to the image
COPY phabricator /opt/phabricator
COPY libphutil   /opt/libphutil
COPY arcanist    /opt/arcanist

# Define working directory
WORKDIR /opt

# Setup repo volume
RUN mkdir -p /var/repo
VOLUME /var/repo

# Setup disk volume
RUN mkdir -p /var/disk
RUN chown -R www-data:www-data /var/disk
VOLUME /var/disk

# Setup extensions volume
RUN mkdir -p /opt/extensions
VOLUME /opt/extensions


# SETUP APACHE
# ============

# Enable necessary mods
RUN a2enmod rewrite

# Clean apache `sites-enabled` directory
RUN a2dissite 000-default

# Add phabricator site configuration
COPY phabricator.conf /etc/apache2/sites-available/phabricator.conf

# Enable phabricator site configuration
RUN a2ensite phabricator

# Set ServerName
RUN echo "ServerName phabricator" >> /etc/apache2/apache2.conf


# SETUP PHP
# =========

# Increase PHP post max size
RUN sed "s/post_max_size.*/post_max_size = 32M/" -i /etc/php5/apache2/php.ini

# Increase PHP `upload_max_filesize`
RUN sed "s/\(upload_max_filesize\).*/\1 = 32M/" -i /etc/php5/apache2/php.ini

# Set PHP Timezone
RUN sed "s|;\(date.timezone\).*|\1 = Europe/Madrid|" -i /etc/php5/apache2/php.ini

# Configure OPcache for production
RUN sed "s|;\(opcache.validate_timestamps\)=1|\1=0|" -i /etc/php5/apache2/php.ini

# Configure `always_populate_raw_post_data` to prevent deprecation warnings
RUN sed "s|;\(always_populate_raw_post_data\).*|\1 = -1|" -i /etc/php5/apache2/php.ini


# SETUP IMAGE
# ===========

# Expose ports
EXPOSE 80

# Set entrypoint
COPY vars.sh /opt/vars.sh
COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]

# Define default command
CMD ["start"]
