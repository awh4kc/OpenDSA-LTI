# https://github.com/phusion/passenger-docker
FROM phusion/passenger-customizable:0.9.27

ENV HOME /root

CMD ["/sbin/my_init"]

RUN /pd_build/ruby-2.3.*.sh
RUN /pd_build/python.sh
RUN /pd_build/nodejs.sh

RUN apt-get update && \
    apt-get upgrade -y -o Dpkg::Options::="--force-confold" && \
    apt-get install -y software-properties-common apt-utils locales tzdata \
    mysql-client
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "America/New_York" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# Enable Nginx and Passenger
RUN rm -f /etc/service/nginx/down

# Configure Nginx and Passenger
RUN rm /etc/nginx/sites-enabled/default
ADD ./docker/webapp.conf /etc/nginx/sites-enabled/webapp.conf
ADD ./docker/secret_key.conf /etc/nginx/main.d/secret_key.conf
ADD ./docker/gzip_max.conf /etc/nginx/conf.d/gzip_max.conf

RUN mkdir /home/app/webapp
WORKDIR /home/app/webapp
COPY . ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

RUN chown -R app:app /home/app/webapp/
RUN chmod -R 775 /home/app/webapp/

# expose the port
EXPOSE 300