ActionMailer::Base.delivery_method = :sendmail 
ActionMailer::Base.smtp_settings = { 
  :address => 'localhost', 
  :domain => 'mail.kekestudio.com', 
  :port => 25 
} 