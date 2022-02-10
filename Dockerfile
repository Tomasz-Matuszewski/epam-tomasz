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
# Get Testlink
#RUN wget -q "https://sourceforge.net/projects/testlink/files/TestLink%201.9/TestLink%201.9.19/testlink-1.9.19.tar.gz/download" -O testlink-1.9.19.tar.gz && \
#    tar zxvf testlink-1.9.19.tar.gz && \
#    mkdir -p /var/www/html/testlink && \
#    mv -f ./testlink-1.9.19/* /var/www/html/testlink && \
#    rm -fr testlink-1.9.19.tar.gz testlink-1.9.19
RUN git clone https://github.com/TestLinkOpenSourceTRMS/testlink-code.git /var/www/html/testlink && \
    rm -fr /var/www/html/testlink/install
# Configure php
RUN echo "max_execution_time=3000" >> /etc/php.ini && \
    echo "session.gc_maxlifetime=60000" >> /etc/php.ini
# Configure testlink
ADD ./config_db.inc.php /var/www/html/testlink
#Create dirs and set permision
RUN mkdir -p /var/testlink /var/testlink/logs /var/testlink/upload_area
RUN chmod 777 -R /var/www/html/testlink && \
    chmod 777 -R /var/testlink/logs && \
    chmod 777 -R /var/testlink/upload_area
# Add user
#RUN groupadd -g 1000 www
#RUN useradd -u 1000 -ms /bin/bash -g www www
#Set permision 
RUN chown -R www-data:www-data /var/www/html/testlink 
# Change current user to www
USER www-data
# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]