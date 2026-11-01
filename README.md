
# justbuchanan.com

Personal website, hosted at https://justbuchanan.com.

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
