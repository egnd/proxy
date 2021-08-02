FROM debian:stretch-slim
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        ca-certificates tzdata privoxy gettext-base && \
    apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* && \
    touch /privoxy.cfg && chown -Rh privoxy /privoxy.cfg

COPY privoxy.cfg /privoxy.cfg.tpl
COPY entrypoint.sh /entrypoint.sh

HEALTHCHECK --interval=60s --timeout=10s --start-period=20s --retries=3 \
    CMD curl -sx http://localhost:8118 'http://p.p/' | grep -qm1 "The Privoxy Team values your feedback"

# @TODO:
# USER privoxy

ENTRYPOINT ["/entrypoint.sh"]

CMD ["--no-daemon", "--user", "privoxy", "/privoxy.cfg"]
