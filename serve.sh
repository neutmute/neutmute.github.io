#!/usr/bin/env bash
set -e
docker run --name myblog --volume="$(pwd):/srv/jekyll" -p 4000:4000 -it jekyll/jekyll:3.8 jekyll serve --watch --drafts
