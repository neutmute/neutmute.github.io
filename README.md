# blog.turbine51.net

## Jekyll CLI

```bash
# Serve locally with live reload (visit http://localhost:4000)
./serve.sh

# Build only
./build.sh

# New blog (one-off)
docker run --volume="$(pwd):/srv/jekyll" --volume=jekyllbundlecache:/usr/local/bundle jekyll/jekyll:3.8 jekyll new .
```