#!/usr/bin/env bash

set -e
DIR=$( dirname $(realpath "$0") )
source $DIR/pid.sh

cd $DIR/../..
yarn prepare
NODE_ENV=development exec .direnv/bin/coffee ${!#}

