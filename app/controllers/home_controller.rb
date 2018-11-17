class HomeController < ApplicationController
	layout "home"
	def index
		
		@message = Message.new
		if current_user && current_user.subscription_id != nil && current_user.subscription_id != ""
			redirect_to '/skynets/new'
		end
	end
	
	def userlist
		@users = User.all
	end

	def create
		@message = Message.new(message_params)

		if @message.valid?
			UserMailer.contact_me(@message).deliver_now
			redirect_to(root_url + "#contact")
			flash[:success] = "Received your message, thanks! We'll contact you later"
		else
			flash[:error] = "Please fill out this form."
			redirect_to(root_url + "#contact")
		end
	end

	private

	def message_params
		params.require(:message).permit(:name, :email, :body)
	end
end
