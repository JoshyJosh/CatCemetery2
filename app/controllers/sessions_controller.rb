class SessionsController < ApplicationController

	def new
		redirect_to "calendar#index", notice: "Logged in!"
	end

	def create
		cust = Customer.find_by(email: params[:email])
		if cust && cust.password == params[:password]
			session[:cust_id] = cust.id
			redirect_to root_url, notice: "Logged in!"
		else
			@login_error = "Improper user name or password"
			render "new"
		end
	end

	def destroy
		session[:cust_id] = nil
		redirect_to root_url, notice: "Logged out!"
	end

	def customer
		redirect_to "/calendar/index"
	end
end
