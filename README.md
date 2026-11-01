
# justbuchanan.com

This repo contains my personal website, which is hosted at https://justbuchanan.com.  It is a single static page built with [Hugo](https://gohugo.io/), and its look comes from the [sustain](https://github.com/biomadeira/sustain) jekyll theme.

Run `hugo server` from the nix dev shell (`nix develop`, or direnv) to preview it.  The flake builds a docker image that serves the site on port 3000:

```bash
nix build .#image
```

```bash
docker load < result
```

```bash
docker run --rm -p 127.0.0.1:3000:3000 justbuchanan.com
```

Every push to master publishes the image to `ghcr.io/justbuchanan/justbuchanan.com`.
