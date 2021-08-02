#!/usr/bin/env bash

envsubst < "/tor.cfg.tpl" > "/tor.cfg"

exec /usr/bin/tor "$@"
