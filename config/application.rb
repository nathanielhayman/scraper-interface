require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Scraper
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Central Time (US & Canada)"
    config.eager_load_paths << Rails.root.join("extras")

    #threads = []

    #threads << Thread.new {
    #  require 'rake'
    #  Scraper::Application.load_tasks

    #  Rake::Task['task_module:run'].invoke
    #  Rake::Task['task_module:run'].execute
    #}

    #threads.each(&:join)
  end
end
