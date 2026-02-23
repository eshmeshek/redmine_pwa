Redmine::Plugin.register :redmine_pwa do
  name 'Redmine PWA'
  author 'eshmeshek'
  description 'Progressive Web App support for Redmine'
  version '1.0.0'
end

Rails.configuration.to_prepare do
  require_dependency 'redmine_pwa/hooks'
end
