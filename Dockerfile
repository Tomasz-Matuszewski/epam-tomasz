FROM php:7.4-fpm
# Set working directory
WORKDIR /var/www/html/testlink
# Install dependencies
RUN apt-get update && apt-get install -y \
    locales \
    zip \
    vim \
    unzip \
    git \
    curl \
    tar \
    wget
# Get Testlink
RUN wget -q "https://sourceforge.net/projects/testlink/files/TestLink%201.9/TestLink%201.9.20/testlink-1.9.20.tar.gz/download" -O testlink-1.9.20.tar.gz && \
    tar zxvf testlink-1.9.20.tar.gz && \
    mv -fT testlink-1.9.20 /var/www/html/testlink && \
    rm testlink-1.9.20.tar.gz
# Configure php
RUN echo "max_execution_time=3000" >> /etc/php.ini && \
    echo "session.gc_maxlifetime=60000" >> /etc/php.ini
# Configure testlink
RUN echo "DB_USER=${USER}" >> /var/www/html/testlink/config_db.inc.php && \
    echo "DB_PASS=${PASS}" >> /var/www/html/testlink/config_db.inc.php && \  
    echo "DB_HOST=${HOST}" >> /var/www/html/testlink/config_db.inc.php && \
    echo "DB_NAME=${DB}" >> /var/www/html/testlink/config_db.inc.php
#Set permision upload & logs
RUN chmod 777 -R /var/www/html/testlink/logs && \
    chmod 777 -R /var/www/html/testlink/upload_area
# Add user
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www
#Set permision 
RUN chown -R www:www /var/www/html/testlink 
# Change current user to www
USER www
# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]