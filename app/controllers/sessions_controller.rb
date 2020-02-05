class SessionsController < ApplicationController
  
  # The new view is where the form is located. 
  def new 
  end

  # This is where the login form submits to. 
  def create 
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        flash[:success] = "Successfully logged in"
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or(@user)
      else
        message = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = "Invalid email/password combination"
      render :new
    end
  end

  # log out
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
