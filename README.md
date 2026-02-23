# Redmine PWA

A lightweight plugin that adds Progressive Web App support to Redmine. Once installed, users can "Add to Home Screen" on mobile devices and get a native app-like experience.

Works with Redmine 6.x (tested on 6.1.1).

## What it does

- Serves a `manifest.json` with your Redmine instance name, theme color, and icons
- Registers a service worker that caches the root page for basic offline fallback
- Injects the necessary `<link>` and `<meta>` tags into every page via Redmine hooks
- Provides default 192x192 and 512x512 app icons

No configuration needed — it picks up your site title from Redmine settings automatically.

## Installation

Clone into your Redmine plugins directory:

```bash
cd /path/to/redmine/plugins
git clone https://github.com/eshmeshek/redmine_pwa.git
```

Restart Redmine, and you're done. The plugin will show up under Administration > Plugins.

**Docker note:** if you're running Redmine in Docker, you may need to copy the icon assets into the public directory manually:

```bash
docker exec redmine mkdir -p /usr/src/redmine/public/plugin_assets/redmine_pwa/images
docker exec redmine cp -r /usr/src/redmine/plugins/redmine_pwa/assets/images/* \
  /usr/src/redmine/public/plugin_assets/redmine_pwa/images/
```

Alternatively, mount a persistent `plugin_assets` volume so they survive container restarts.

## Custom icons

Replace the PNG files in `assets/images/`:

- `icon-192.png` — 192x192 pixels
- `icon-512.png` — 512x512 pixels

Clear browser cache or reinstall the PWA after replacing them.

## HTTPS

Service workers require HTTPS in production. On localhost/HTTP the manifest and meta tags will still be injected, but the browser won't actually register the service worker. Set up a reverse proxy with TLS (nginx, Caddy, etc.) for full PWA functionality.

## How it works

The plugin has three parts:

1. **`PwaController`** — serves `/pwa/manifest.json` and `/pwa/sw.js`
2. **`RedminePwa::Hooks`** — injects manifest link, theme-color meta, apple-mobile-web-app tags, and the SW registration script into `<head>`
3. **Service worker** — minimal fetch handler that falls back to a cached copy of `/` when the network is unavailable

## License

MIT
