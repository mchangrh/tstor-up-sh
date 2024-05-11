FROM alpine
RUN apk update && \
    apk add --no-cache \
        bash \
        curl \
        wget \
        jq \
        unzip
COPY update.sh /update.sh
CMD ["/update.sh"]