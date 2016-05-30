require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ImgurUrl
  class Image
    def id
      matches = @original_url.match(%r{^http://(?:i\.)?imgur\.com/(?:download/)?([^.#?/]{5,})})

      if matches[1] == 'gallery'
        @id ||=  @original_url.match(%r{^http://(?:i\.)?imgur\.com/gallery/(?:download/)?([^.#?/]{5,})}).andand[1]
      else
        @id ||= matches.andand[1]
      end
    end
  end
end

module Treddit
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.cache_store = :redis_store, ENV.fetch('REDIS_URL')

    config.action_cable.mount_path = '/cable'
    config.action_cable.allowed_request_origins = ENV.fetch('ALLOWED_REQUEST_ORIGINS')
    config.action_cable.url = ENV.fetch('ACTION_CABLE_URL')
  end
end
