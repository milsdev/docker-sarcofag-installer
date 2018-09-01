FROM milsdev/default-php7

WORKDIR /var/www/default

RUN apt-get update

RUN echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list
RUN echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list

RUN apt-get install -y ca-certificates gnupg wget curl git bzip2

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

RUN wget https://www.dotdeb.org/dotdeb.gpg
RUN apt-key add dotdeb.gpg
RUN apt-get update

RUN apt-get install mysql-client -y

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV THEME_NAME mils

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh
