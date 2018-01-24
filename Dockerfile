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
    mysql-client \
    python-pip

RUN pip install --upgrade pip
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "America/New_York" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# Install Java.
# https://github.com/dockerfile/java
# https://github.com/dockerfile/java/tree/master/oracle-java8
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

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
RUN pip install -r public/OpenDSA/requirements.txt --upgrade

RUN chown -R app:app /home/app/webapp/
RUN chmod -R 775 /home/app/webapp/

# expose the port
EXPOSE 3000