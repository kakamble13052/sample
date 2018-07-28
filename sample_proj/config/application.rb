require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SampleProj
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.time_zone = 'New Delhi'
    config.set_time_zone = :local
    config.after_initialize do
      Rails.application.load_tasks
      Rake::Task["update_ops:update_role"].invoke
      Rake::Task["update_ops:update_archived_values"].invoke
      Rake::Task["update_ops:send_deadline_expired_mail"].invoke
      #Rake::Task["update_ops:sample_tasks"].invoke
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
