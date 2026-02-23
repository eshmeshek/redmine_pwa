class PwaController < ApplicationController
  skip_before_action :check_if_login_required
  skip_before_action :verify_authenticity_token

  def manifest
    render json: {
      name: Setting.app_title.presence || 'Redmine',
      short_name: 'Redmine',
      start_url: '/',
      display: 'standalone',
      background_color: '#ffffff',
      theme_color: '#628DB6',
      orientation: 'any',
      icons: [
        {
          src: '/plugin_assets/redmine_pwa/images/icon-192.png',
          sizes: '192x192',
          type: 'image/png'
        },
        {
          src: '/plugin_assets/redmine_pwa/images/icon-512.png',
          sizes: '512x512',
          type: 'image/png'
        }
      ]
    }
  end

  def service_worker
    response.headers['Content-Type'] = 'application/javascript'
    response.headers['Service-Worker-Allowed'] = '/'
    render plain: <<~JS
      const CACHE_NAME = 'redmine-pwa-v1';
      const OFFLINE_URL = '/';

      self.addEventListener('install', (event) => {
        event.waitUntil(
          caches.open(CACHE_NAME).then((cache) => cache.add(OFFLINE_URL))
        );
        self.skipWaiting();
      });

      self.addEventListener('activate', (event) => {
        event.waitUntil(
          caches.keys().then((names) =>
            Promise.all(
              names.filter((n) => n !== CACHE_NAME).map((n) => caches.delete(n))
            )
          )
        );
        self.clients.claim();
      });

      self.addEventListener('fetch', (event) => {
        if (event.request.mode === 'navigate') {
          event.respondWith(
            fetch(event.request).catch(() => caches.match(OFFLINE_URL))
          );
        }
      });
    JS
  end
end
