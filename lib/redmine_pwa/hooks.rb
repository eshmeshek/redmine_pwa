module RedminePwa
  class Hooks < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context = {})
      tags = []
      tags << '<link rel="manifest" href="/pwa/manifest.json">'
      tags << '<meta name="theme-color" content="#628DB6">'
      tags << '<meta name="apple-mobile-web-app-capable" content="yes">'
      tags << '<meta name="apple-mobile-web-app-status-bar-style" content="default">'
      tags << '<link rel="apple-touch-icon" href="/plugin_assets/redmine_pwa/images/icon-192.png">'
      tags << '<script>if("serviceWorker" in navigator){navigator.serviceWorker.register("/pwa/sw.js",{scope:"/"})}</script>'
      tags.join("\n").html_safe
    end
  end
end
