# Build custom image with non root user
FROM influxdb:1.8.3

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    ca-certificates \
	  curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY init.iql  /docker-entrypoint-initdb.d/

HEALTHCHECK --interval=10s --timeout=2s CMD curl -sI 127.0.0.1:8086/ping | grep -q "204 No Content"