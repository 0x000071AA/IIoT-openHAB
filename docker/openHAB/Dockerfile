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
    GROUP_ID="9001" \
    KARAF_EXEC="exec" \
    LC_ALL="en_US.UTF-8" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    OPENHAB_HOME="/openhab" \
    OPENHAB_HTTP_PORT="5000" \
    OPENHAB_HTTPS_PORT="5001" \
    OPENHAB_OPC_PORT="4840" \
    OPENHAB_OPC_SECURE_PORT="4843" \
    OPENHAB_LOGDIR="/openhab/userdata/logs" \
    OPENHAB_USERDATA="/openhab/userdata" \
    OPENHAB_CERTIFICATES="/openhab/certificates" \
    USER_ID="9001"

#TODO: CHECK if possible
#COPY entrypoint.sh /entrypoint.sh

# install packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    ca-certificates \
    curl \
    tini \
    gosu && \
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
VOLUME ${OPENHAB_HOME} ${OPENHAB_USERDATA} ${OPENHAB_CERTIFICATES} ${OPENHAB_HOME}/addons
# Adapt ports	
EXPOSE ${OPENHAB_HTTP_PORT} ${OPENHAB_HTTPS_PORT} ${OPENHAB_OPC_PORT} ${OPENHAB_OPC_SECURE_PORT} 8101 5007

HELACHECK --interval=20s --timeout=2s CMD curl --silent --fail http://localhost:5000/rest || exit 1

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["gosu", "openhab", "tini", "-s", "./start.sh"]
