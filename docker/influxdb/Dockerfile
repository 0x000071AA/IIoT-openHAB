# Build custom image with non root user
FROM influxdb
COPY init.iql  /docker-entrypoint-initdb.d/

#TODO: Add
#HEALTHCHECK --interval=5s --retries=24 --timeout=1s CMD curl -sI 127.0.0.1:8086/ping | grep -q "204 No Content"