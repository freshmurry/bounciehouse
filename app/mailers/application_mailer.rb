class ApplicationMailer < ActionMailer::Base
  default from: 'info@bounciehouse.com', bcc: 'admin@bounciehouse.com'
  layout 'mailer'
end
