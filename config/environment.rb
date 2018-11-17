# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

if Rack::Utils.respond_to?("key_space_limit=")
  Rack::Utils.key_space_limit = 78643204
end

# ActionMailer::Base.smtp_settings = {
#   :address        => 'smtp.sendgrid.net',
#   :port           => '587',
#   :authentication => :plain,
#   :user_name      => ENV['SENDGRID_USERNAME'],
#   :password       => ENV['SENDGRID_PASSWORD'],
#   :domain         => 'heroku.com',
#   :enable_starttls_auto => true
# }

ActionMailer::Base.smtp_settings = {
  :address        => 'email-smtp.us-west-2.amazonaws.com',
	:port           => '587',
	:authentication => :login,
	:user_name      => 'AKIAIAD7JQELR4KIDZ4Q',
	:password       => 'Ai7hwT82T7GWX1PGHQb2376e6OJWwZmyCHKyWVBXtbM6',
	:enable_starttls_auto => true
}