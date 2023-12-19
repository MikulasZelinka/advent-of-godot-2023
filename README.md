# Advent of Godot 2023

[![Netlify Status](https://api.netlify.com/api/v1/badges/80d61a7a-c980-484a-a6c3-725b2cef105a/deploy-status)](https://app.netlify.com/sites/advent-of-godot-2023/deploys)

## TODO

## Quick tunnel share

```bash
wget https://raw.githubusercontent.com/godotengine/godot/master/platform/web/serve.py -P build
```

Then, assuming you have a local build in `build/web`, run:

```bash
python build/serve.py -n -r web
```

and in another terminal:

```bash
cloudflared tunnel --url 0.0.0.0:8060
```
