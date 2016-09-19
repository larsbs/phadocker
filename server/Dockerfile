# Base image
FROM fedora:24

LABEL phabricator=server


# DEPENDENCIES
# ============

# Install `apt-get` packages
RUN dnf update && dnf install -y \
  git \
  httpd \
  php \
  php-mysql \
  php-apcu \
  php-curl \
  php-gd \
  python-pygments \
  mysql \
  sendmail \
  && dnf clean all


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

# Create sites folders
RUN mkdir -p /etc/httpd/sites-available
RUN mkdir -p /etc/httpd/sites-enabled

# Add sites folders to httpd.confd
RUN echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf

# Add phabricator site configuration
COPY phabricator.conf /etc/httpd/sites-available/phabricator.conf

# Enable phabricator site configuration
RUN ln -s /etc/httpd/sites-available/phabricator.conf /etc/httpd/sites-enabled/phabricator.conf

# Set default ServerName
RUN echo "ServerName phabricator" >> /etc/httpd/conf/httpd.conf


# SETUP PHP
# =========

# Increase PHP post max size
RUN sed "s/post_max_size.*/post_max_size = 32M/" -i /etc/php.ini

# Increase PHP `upload_max_filesize`
RUN sed "s/\(upload_max_filesize\).*/\1 = 32M/" -i /etc/php.ini

# Set PHP Timezone
RUN sed "s|;\(date.timezone\).*|\1 = Europe/Madrid|" -i /etc/php.ini

# Configure OPcache for production
RUN sed "s|;\(opcache.validate_timestamps\)=1|\1=0|" -i /etc/php.ini

# Configure `always_populate_raw_post_data` to prevent deprecation warnings
RUN sed "s|;\(always_populate_raw_post_data\).*|\1 = -1|" -i /etc/php.ini


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
