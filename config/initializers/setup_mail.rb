ActionMailer::Base.smtp_settings = {
  :address              => Settings.email_server,
  :port                 => 25,
  :domain               => Settings.domain,
  :user_name            => Settings.email_sender,
  :password             => Settings.email_password,
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "localhost:3000"
# Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?