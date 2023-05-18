FROM mariadb:10.11-rc

ENV MYSQL_ROOT_PASSWORD='pgeti'
ENV MYSQL_DATABASE='astro'

COPY ./create_db.sql /docker-entrypoint-initdb.d
