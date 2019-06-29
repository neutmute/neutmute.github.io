# Jekyll CLI

```
$env:JEKYLL_VERSION=3.8



	
# New blog
docker run --volume=${PWD}:/srv/jekyll --volume=jekyllbundlecache:/usr/local/bundle jekyll/jekyll jekyll new .

# build
docker run --rm --volume="${PWD}:/srv/jekyll" -it jekyll/jekyll jekyll build

# serve & watch
docker run --name myblog --volume="${PWD}:/srv/jekyll" -p 4000:4000 -it jekyll/jekyll jekyll serve --watch --drafts
```