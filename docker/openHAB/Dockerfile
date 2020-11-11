FROM alpine:3.7 AS deploy-openhab
RUN apk add --no-cache zip unzip
WORKDIR /dist/openhab
COPY /distro/openhab.zip .
RUN unzip -q openhab.zip -x "*.bat" "*.ps1" "*.psm1" && \
    rm openhab.zip && \
	echo 'deployed openhab'

FROM amd64/debian:10.5-slim AS deploy-java
ENV \
    JAVA_HOME="8" \
    JAVA_HOME="/usr/lib/jvm" \
    CRYPTO_POLICY="unlimited"
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
	  ca-certificates \
		wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /usr/lib/jvm	
RUN wget -nv -O /tmp/java.tar.gz "https://cdn.azul.com/zulu/bin/zulu8.48.0.53-ca-jdk8.0.265-linux_x64.tar.gz" && \
    tar --exclude='demo' --exclude='sample' --exclude='src.zip' -xf /tmp/java.tar.gz --strip-components=1 -C "${JAVA_HOME}" && \
	if [ "${JAVA_VERSION}" = "8" ]; then \
		sed -i 's/^#crypto.policy=unlimited/crypto.policy=unlimited/' "${JAVA_HOME}/jre/lib/security/java.security"; \
	fi && \
	rm /tmp/java.tar.gz

FROM amd64/debian:10.5-slim

ENV \
	JAVA_HOME="/usr/lib/jvm" \
	JAVA_MIN_MEM="256M" \
	JAVA_MAX_MEM="256M" \
  EXTRA_JAVA_OPTS="-Xbootclasspath/a:/openhab/conf/automation/jython/jython-standalone-2.7.2.jar -Dpython.home=/openhab/conf/automation/jython -Dpython.path=/openhab/conf/automation/lib/python" \
  GROUP_ID="9001" \
  KARAF_EXEC="exec" \
  LC_ALL="en_US.UTF-8" \
  LANG="en_US.UTF-8" \
  LANGUAGE="en_US.UTF-8" \
  OPENHAB_BACKUPS="/openhab/userdata/backup" \
  OPENHAB_CONF="/openhab/conf" \
  OPENHAB_HOME="/openhab" \
  OPENHAB_HTTP_PORT="5000" \
  OPENHAB_HTTPS_PORT="5001" \
	OPENHAB_OPC_PORT="4840" \
	OPENHAB_OPC_SECURE_PORT="4843" \
  OPENHAB_LOGDIR="/openhab/userdata/logs" \
  OPENHAB_USERDATA="/openhab/userdata" \
	OPENHAB_CERTIFICATES="/openhab/certificates" \
  USER_ID="9001"

ARG BUILD_DATE
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.license="EPL-2.0" \
    org.label-schema.vendor="Lotus GmbH & Co KG" \
    org.label-schema.version=$VERSION \
    maintainer="Tim Weber"

#TODO: CHECK if possible
#COPY entrypoint.sh /entrypoint.sh

# install packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    ca-certificates \
	  curl \
		tini \
		gosu \
		arping && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* #&& \
	#chmod +x /entrypoint.sh

# install java
WORKDIR ${JAVA_HOME}
COPY --from=deploy-java ${JAVA_HOME} .

# install openhab
WORKDIR ${OPENHAB_HOME}
COPY --from=deploy-openhab /dist/openhab .

# TODO: remove ${OPENHAB_HOME}/addons after testing
VOLUME ${OPENHAB_CONF} ${OPENHAB_USERDATA} ${OPENHAB_CERTIFICATES} ${OPENHAB_HOME}/addons ${OPENHAB_BACKUPS}

# Adapt ports	
EXPOSE ${OPENHAB_HTTP_PORT} ${OPENHAB_HTTPS_PORT} ${OPENHAB_OPC_PORT} ${OPENHAB_OPC_SECURE_PORT} 8101 5007

HELACHECK --interval=20s --timeout=2s CMD curl --silent --fail http://localhost:5000/rest || exit 1

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["gosu", "openhab", "tini", "-s", "./start.sh"]