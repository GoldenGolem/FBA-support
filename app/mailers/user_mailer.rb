class UserMailer < ApplicationMailer
	default from: 'www.fba.support'

	def welcome_email(email, message)
		@email = email
		@message = message
		@url = 'www.fba.support/skynets/new'
		mail(to: @email, subject: @message)
	end

	def receive(email)
	    page = Page.find_by(address: email.to.first)
	    page.emails.create(
	      subject: email.subject,
	      body: email.body
	    )
	 
	    if email.has_attachments?
	      email.attachments.each do |attachment|
	        page.attachments.create({
	          file: attachment,
	          description: email.subject
	        })
	      end
	    end
	end

	def registration_confirmation(user)
	  recipients  user.email
	  from        "webmaster@example.com"
	  subject     "Thank you for Registering"
	  body        :user => user
	end

	def contact_me(message)
		@body = message.body
		mail to: "steven@fba.support", from: message.email, 'Reply-to': message.email, subject: "FBA.Support question from " + message.name
		mail to: "coolJenny009g@gmail.com", from: message.email, 'Reply-to': message.email, subject: "FBA.Support question from " + message.name + "-(" + message.email + ")"
	end

	def send_email
		@body = "test email";
		mail to: "kumhyokkim@gmail.com", from: "kam@fba.support", 'Reply-to': "steven@fba.support", subject: "FBA.Support question from "
	end

	def send_skynetnotification(user, skynet)
		@url = skynet.outputfileurl
		@status = skynet.skynet_status.name
		mail to: "kumhyokkim@gmail.com", from:  "kam@fba.support", 'Reply-to': "steven@fba.support", subject: "FBA.Support file processing is done."
	end

end
