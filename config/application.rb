require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module KollectoSgSurveyBuilder
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

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

    ActionMailer::Base.delivery_method = :smtp # be sure to choose SMTP delivery
    ActionMailer::Base.smtp_settings = {
        :address              => "smtp.mandrillapp.com",
        :port                 => 25,
        :domain               => "kollecto.sb.mackinleysmith.com",
        :user_name            => Rails.application.secrets.mandrill_user_name,
        :password             => Rails.application.secrets.mandrill_api_key,
        :authentication       => 'login',
        :enable_starttls_auto =>  true,
        :openssl_verify_mode => 'none'
    }

  end
end
