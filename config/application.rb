require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ApiMuncher
  class Application < Rails::Application
    config.generators do |g|
      # Force new test files to be generated in the minitest-spec style
      g.test_framework :minitest, spec: true

      # Always use .js files, never .coffee
      g.javascript_engine :js


    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.


    # Automatically load all code from <rails_root>/lib
    config.autoload_paths << Rails.root.join('lib')

  end
end
