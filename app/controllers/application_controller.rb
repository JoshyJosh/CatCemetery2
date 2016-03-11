class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_customer
  	if session[:cust_id]
  		@cust ||= Customer.find(session[:cust_id])
  	end
  end
  helper_method :current_customer

  def logged_customer
  	redirect_to root_url unless current_customer
  end
end
