FROM alpine
RUN apk update && \
    apk add --no-cache \
        bash \
        curl \
        wget \
        jq \
        unzip
COPY --chmod=0755 update.sh /update.sh
CMD ["/update.sh"]