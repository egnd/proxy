#!/usr/bin/env bash

envsubst < "/privoxy.cfg.tpl" > "/privoxy.cfg"

# @TODO: adblock filters

exec /usr/sbin/privoxy "$@"
