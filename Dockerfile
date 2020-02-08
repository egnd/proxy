FROM alpine
COPY entrypoint.sh /usr/local/bin/tor-entrypoint
RUN apk --quiet --no-cache --no-progress add curl tor shadow && \
    echo 'DataDirectory /var/lib/tor' >>/etc/tor/torrc && \
    echo 'User tor' >>/etc/tor/torrc && \
    echo 'AutomapHostsOnResolve 1' >>/etc/tor/torrc && \
    echo 'ExitPolicy reject *:*' >>/etc/tor/torrc && \
    echo 'SocksPort 0.0.0.0:9050 IsolateDestAddr' >>/etc/tor/torrc && \
    mkdir -p /etc/tor/run && \
    chown -Rh tor. /var/lib/tor /etc/tor/run && \
    rm -rf /tmp/* /var/tmp/*
HEALTHCHECK --interval=60s --timeout=15s --start-period=20s \
    CMD curl -sx socks5://localhost:9050 'https://check.torproject.org/' | grep -qm1 Congratulations
VOLUME ["/etc/tor", "/var/lib/tor"]
EXPOSE 9050
ENTRYPOINT ["tor-entrypoint"]
CMD ["tor"]

#@TODO: https://hub.docker.com/r/dperson/torproxy/
