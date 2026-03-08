# blog.turbine51.net

## Jekyll CLI

```bash
# Serve locally with live reload (visit http://localhost:4000)
./serve.sh

# Build only
./build.sh

# New blog (one-off)
docker run --volume="$(pwd):/srv/jekyll" --volume=jekyll-bundle-cache:/usr/local/bundle jekyll/jekyll:pages jekyll new .
```