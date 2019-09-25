FROM registry.cn-beijing.aliyuncs.com/rdc-public-images/php7.3-fpm:latest

RUN mkdir -p /var/app

ADD application.tar.gz /var/app

RUN chmod -R 775 /var/app/storage && chown -R www-data:www-data /var/app
