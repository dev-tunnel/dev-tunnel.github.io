FROM ubuntu:24.04
RUN apt-get update && apt-get install -y apache2 apache2-utils 
RUN apt clean 
RUN a2enmod headers
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY index.html /var/www/html/index.html
COPY .well-known/.htaccess /var/www/html/.well-known/.htaccess
COPY .well-known/webauthn.json /var/www/html/.well-known/webauthn
EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-X"]
