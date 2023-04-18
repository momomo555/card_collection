require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module CardCollection
  class Application < Rails::Application
    config.load_defaults 7.0

    config.generators do |g|
      g.helper false
      g.test_framework :rspec,
        fixtures: false,
        view_specs: false,
        helper_specs: false,
        routing_specs: false
    end

    config.i18n.default_locale = :ja
    config.time_zone = 'Tokyo'
  end
end
