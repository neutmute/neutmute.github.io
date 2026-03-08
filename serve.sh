#!/usr/bin/env bash
set -e
docker rm -f myblog 2>/dev/null || true
docker run --name myblog \
  --volume="$(pwd):/srv/jekyll" \
  --volume="jekyll-bundle-cache:/usr/local/bundle" \
  -p 4000:4000 -it jekyll/jekyll:pages \
  jekyll serve --watch --drafts
