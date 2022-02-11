FROM php:7.4-fpm
# Install dependencies
RUN apt-get update && apt-get install -y \
    locales \
    zip \
    vim \
    unzip \
    git \
    curl \
    tar \
    wget \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    && docker-php-ext-install mysqli \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd
#Get testlink 
RUN git clone https://github.com/TestLinkOpenSourceTRMS/testlink-code.git /var/www/html/testlink && \
    rm -fr /var/www/html/testlink/install
COPY ./conf/testlink/* /opt/scripts/
RUN chmod 777 -R /opt/scripts
# Configure php
RUN echo "max_execution_time=3000" >> /etc/php.ini && \
    echo "session.gc_maxlifetime=60000" >> /etc/php.ini
# Configure testlink
ADD ./conf/config_db.inc.php /var/www/html/testlink
#Create dirs and set permision
RUN mkdir -p /var/testlink /var/testlink/logs /var/testlink/upload_area
RUN chmod 777 -R /var/www/html/testlink && \
    chmod 777 -R /var/testlink/logs && \
    chmod 777 -R /var/testlink/upload_area
RUN chown -R www-data:www-data /var/www/html/testlink 
# Change current user to www-data
USER www-data
# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["sh","-c","/opt/scripts/run.sh && php-fpm"]