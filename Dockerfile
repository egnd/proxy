FROM alpine
COPY entrypoint.sh /usr/local/bin/tor-entrypoint
RUN apk --quiet --no-cache --no-progress add curl tor && \
    rm -rf /tmp/* /var/tmp/*
HEALTHCHECK --interval=60s --timeout=15s --start-period=20s \
    CMD curl -sx socks5://localhost:9050 'https://check.torproject.org/' | grep -qm1 Congratulations
EXPOSE 9050
ENTRYPOINT ["tor-entrypoint"]
CMD ["tor"]

#@TODO: https://hub.docker.com/r/dperson/torproxy/
