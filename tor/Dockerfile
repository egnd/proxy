FROM debian:buster-slim

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        ca-certificates tzdata tor curl gettext-base && \
    apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* && \
    useradd -ms /bin/bash tor && \
    touch /tor.cfg && mkdir -p /etc/tor/run && \
        chown -Rh tor /var/lib/tor /etc/tor/run /tor.cfg && chmod 0750 /etc/tor/run

HEALTHCHECK --interval=60s --timeout=10s --start-period=20s --retries=3 \
    CMD curl -sx socks5://localhost:9050 'https://check.torproject.org/' | grep -qm1 Congratulations

COPY tor.cfg /tor.cfg.tpl
COPY entrypoint.sh /entrypoint.sh

USER tor

ENTRYPOINT ["/entrypoint.sh"]
CMD ["-f", "/tor.cfg"]
