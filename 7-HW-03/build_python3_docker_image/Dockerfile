FROM python:3.8-slim-buster

WORKDIR /python-docker

COPY requirements.txt requirements.txt
RUN pip install psycopg2-binary
RUN pip3 install -r requirements.txt
RUN mkdir -p /srv/app
RUN mkdir -p /srv/app/conf
CMD [ "python3", "/srv/app/web.py"]