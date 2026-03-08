# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Jekyll blog (blog.turbine51.net) using the Minima theme, hosted on GitHub Pages. Posts cover C#/.NET dev, Raspberry Pi hardware projects, OpenHAB/smart home, and maker topics. Jekyll version: ~3.8.5.

## Commands

Development is done via Docker (no local Ruby/Jekyll install required):

```powershell
# Serve locally with live reload (visit http://localhost:4000)
docker run --name myblog --volume="${PWD}:/srv/jekyll" -p 4000:4000 -it jekyll/jekyll jekyll serve --watch --drafts

# Build only
docker run --rm --volume="${PWD}:/srv/jekyll" -it jekyll/jekyll jekyll build
```

Publishing is done by pushing to `master` — GitHub Pages builds and deploys automatically.

## Content Structure

- `_posts/` — all blog posts, named `YYYY-MM-DD-title.md` or `.html`
- `assets/img/` — images; `assets/ico/` — icons
- `_config.yml` — site title, URL, theme, plugins
- `index.md` — homepage (uses `layout: home`)

## Post Frontmatter

Posts use this frontmatter pattern:

```yaml
---
layout: post
title: 'Post Title'
categories:
  blog
excerpt: Short description shown in listings
---
```

## Key Config

- Theme: `minima` (~2.0)
- Markdown: kramdown
- Plugin: `jekyll-feed`
- Comments enabled (`comments: true` in `_config.yml`)
- Site URL: `http://blog.turbine51.net`
