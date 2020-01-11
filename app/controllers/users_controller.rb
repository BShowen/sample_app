class UsersController < ApplicationController
  before_action :require_login, only: [:index, :show]
  
  def new
    @user = User.new
  end

  def update
  end

  def edit
    @user = User.find_by(id: 4)
    render :new
  end

  def show
      @user = User.find_by(id: params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      remember @user # I added this line of code. This isnt in the tutorial. 
      flash[:success] = "Welcome to the sample app!"
      redirect_to user_path(@user.id)
    else
      render :new
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end 

    def require_login
      if !logged_in?
        flash[:warning] = "You must be logged in"
        redirect_to login_path 
      end
    end
end
