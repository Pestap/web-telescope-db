FROM mariadb:10.11-rc

ENV MYSQL_ROOT_PASSWORD='pgeti'

COPY ./create_db.sql /docker-entrypoint-initdb.d
