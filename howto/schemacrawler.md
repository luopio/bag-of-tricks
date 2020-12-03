PUT YER DATABASE SOMEWHERE
mysql --user=root --password=root --port=32768 --host="127.0.0.1" < devmaster.sql

RUN A SCHEMACRAWLER IMAGE TO GET THE COMMAND
docker run -v $(pwd):/home/schcrwlr/share --name schemacrawler --rm -i -t --entrypoint=/bin/bash schemacrawler/schemacrawler


INSIDE the container something like:

schemacrawler --server=mysql --host="172.17.0.1" --port=32768 --database=devmaster --command=schema --output-format=png --output-file=/home/schcrwlr/share/fitnessbrokerschema.png --info-level=standard --user root --password root
