#!/usr/bin/env bash

set -e
set -o pipefail
set -C


APP=$(basename $PWD | sed -e 's/^docker\-//')
TAG="$USER/$APP"

DOCKER_OPT=""
WP_CLI_HOME=/home/wp-cli
WP_CLI_WP_PATH=/var/www/html

if [[ -f "$PWD/.env" ]]; then
    DOCKER_OPT="--env-file $PWD/.env"
fi
if [[ -d "$PWD/.ssh" ]]; then
    DOCKER_OPT="$DOCKER_OPT --mount type=bind,src=$PWD/.ssh,dst=$WP_CLI_HOME/.ssh,readonly"
fi
if [[ -f "$PWD/wp-cli.yml" ]]; then
    DOCKER_OPT="$DOCKER_OPT --mount type=bind,src=$PWD/wp-cli.yml,dst=$WP_CLI_HOME/wp-cli.yml,readonly"
fi
if [[ -n "$WP_PATH" ]]; then
    DOCKER_OPT="$DOCKER_OPT --mount type=bind,src=$WP_PATH,dst=$WP_CLI_WP_PATH -e WP_PATH=$WP_CLI_WP_PATH"
fi

docker run --rm $DOCKER_OPT -it $TAG:latest $@
