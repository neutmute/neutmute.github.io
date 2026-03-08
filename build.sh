#!/usr/bin/env bash
set -e
docker run --rm \
  --volume="$(pwd):/srv/jekyll" \
  --volume="jekyll-bundle-cache:/usr/local/bundle" \
  -it jekyll/jekyll:pages \
  jekyll build
