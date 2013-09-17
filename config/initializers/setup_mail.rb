ActionMailer::Base.smtp_settings = {
  :address              => "smtp.sina.com",
  :port                 => 25,
  :domain               => "127.0.0.1:3000",
  :user_name            => "kekestudio@sina.com",
  :password             => "",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "localhost:3000"
# Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?