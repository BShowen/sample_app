class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :valid_link, only: [:edit, :update]
  
  def new
  end

  def edit
  end

  # this is where the reset password form submits to. 
  def create
    @user = User.find_by(email: params[:password_reset][:email])
    if @user
      flash[:info] = "Check your email for instructions"
      @user.create_reset_digest
      @user.send_password_reset_email
      redirect_to root_url
    else
      flash.now[:danger] = "An account with that email could not be found"
      render :new
    end
  end

  # this is where the create new password form submits to
  def update
    if user_params[:password].empty? # a failed update due to empty password 
      @user.errors.add(:password, "Password cant be empty")
      render :edit
    elsif @user.update_attributes(user_params) # a successful update
      log_in @user
      flash[:success] = "Password has been reset"
      @user.update_attribute(:reset_digest, nil)
      redirect_to @user
    else # a failed update due to mismatched password and password_confirmation
      render :edit
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def valid_link
      if @user.reset_sent_at + 2.hours < Time.zone.now
        flash[:danger] = "Expired link"
        redirect_to new_password_reset_url
      end
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    def valid_user
      unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
        redirect_to root_url
      end
    end
end
