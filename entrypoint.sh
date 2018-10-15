#!/bin/sh
echo "$(date) running in MIX_ENV=$MIX_ENV"

mix compile
mix phoenix.server
