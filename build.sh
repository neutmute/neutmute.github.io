#!/usr/bin/env bash
set -e
docker run --rm --volume="$(pwd):/srv/jekyll" -it jekyll/jekyll:3.8 jekyll build
