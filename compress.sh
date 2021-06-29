#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")"; pwd)
set -ex
cd $DIR

zstd -f -6 -D zstd.dict txt.txt
