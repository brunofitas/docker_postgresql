FROM ubuntu:14.04

MAINTAINER Bruno Fitas <brunofitas@gmail.com>

RUN sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

RUN apt-get update

RUN sudo apt-get -y install wget ca-certificates

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

RUN apt-get update && apt-get install -y python-software-properties software-properties-common postgresql-9.5-postgis-2.2 postgresql-client-9.5 postgresql-contrib-9.5

USER postgres

RUN    /etc/init.d/postgresql start  && psql --command "CREATE USER psql_admin WITH SUPERUSER PASSWORD 'psql_pass#6547';" \
    && createdb --owner=psql_admin --template=template0 --encoding=Unicode psql_admin

RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.5/main/pg_hba.conf

RUN echo "listen_addresses='*'" >> /etc/postgresql/9.5/main/postgresql.conf

EXPOSE 5432

VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

CMD ["/usr/lib/postgresql/9.5/bin/postgres", "-D", "/var/lib/postgresql/9.5/main", "-c", "config_file=/etc/postgresql/9.5/main/postgresql.conf"]
