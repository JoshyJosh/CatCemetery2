class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #before_action :check_customer
  before_action :authenticate_customer!


	#def check_customer
	#	return if (request.fullpath == new_customer_session_path) || (request.fullpath == new_customer_registration_path)
	#						|| (request.fullpath == new_customer_password) || (request.fullpath == new)
	#	redirect_to new_customer_session_path unless current_customer

	#end

	def logout_customer
		@notice = "foo"
		sign_out_and_redirect("/")
	end

end
