require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Koresuki
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.railties_order = [ActiveStorage::Engine, :main_app, :all]
    # ActiveStorageがエラーページのルーティングの影響で動かなくなるため
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }
    config.i18n.default_locale = :ja
  end
end
