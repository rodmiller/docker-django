FROM ubuntu:trusty

MAINTAINER robmiller

RUN apt-get update
RUN apt-get install -y python3 python3-pip python3-dev sqlite3 supervisor python-setuptools
#RUN add-apt-repository -y ppa:nginx/stable
#RUN apt-get update
RUN apt-get install -y nginx
RUN apt-get install -y libjpeg-dev zlib1g-dev


RUN mkdir -p /code/app

ADD ./* /code/
RUN pip3 install -r /code/requirements.txt
RUN pip3 install uwsgi

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default

RUN ln -s /code/nginx-app.conf /etc/nginx/sites-enabled/
RUN ln -s /code/supervisor-app.conf /etc/supervisor/conf.d/

RUN django-admin startproject website /code/app
RUN cd /code/app && python3 ./manage.py syncdb --noinput

EXPOSE 80
CMD ["supervisord", "-n"]


