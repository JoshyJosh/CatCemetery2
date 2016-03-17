class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #before_action :check_customer
  before_action :authenticate_customer!
  before_action :configure_permitted_parameters, if: :devise_controller?

	def logout_customer
		@notice = "foo"
		sign_out_and_redirect("/")
	end
	
	protected
	# Mostly useless but would use it for welcome page
	def configure_permitted_parameters
		devise_parameter_sanitizer.for(:sign_up) << :name
	end

end
