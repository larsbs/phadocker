# Base image
FROM mysql:5.6

LABEL phabricator=database


# CONFIGURE MYSQL
# ===============

# Add custom config
RUN rm /etc/mysql/my.cnf
COPY my.cnf /etc/mysql/my.cnf
RUN rm /usr/my.cnf
COPY my.cnf /usr/my.cnf


# SETUP IMAGE
# ===========

# Add phabricator stopwords
COPY stopwords.txt /opt/stopwords.txt

# Set volume
VOLUME /var/lib/mysql

# Expose ports
EXPOSE 3306

# Set working directory
WORKDIR /opt

# Set entrypoint
COPY vars.sh /opt/vars.sh
COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]

# Set default command
CMD ["mysqld_safe"]
