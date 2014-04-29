require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Merikotkat
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Helsinki'
    #config.active_record.default_timezone = 'Helsinki'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.enforce_available_locales = true
    config.i18n.default_locale = :fi
    config.cache_store = :memory_store  # hope this doesnt break anything else...

    #todo not needed for production hopefully...
    ENV['PATH'] += File::PATH_SEPARATOR + 'C:\Program Files\ImageMagick-6.8.8-Q16'

    # Set ProductionMode false if deployment is staging and true if real production
    ENV['ProductionMode'] = 'false'

  end
end
