#!/usr/bin/env bash
set -e
docker run --rm \
  --volume="$(pwd):/srv/jekyll" \
  --volume="jekyll-bundle-cache:/usr/local/bundle" \
  -it jekyll/jekyll:pages \
  sh -c "apk add --no-cache build-base cmake >/dev/null 2>&1 && jekyll build"
