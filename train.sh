#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")"; pwd)
set -ex
cd $DIR

./parse.coffee ./log/20210629.log
zstd --train ./txt/* -o zstd.dict
