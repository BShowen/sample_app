class UsersController < ApplicationController
  before_action :ensure_logged_in,      only: [:edit, :update, :index, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :ensure_admin, only: [:destroy]

  # create a new user then render the sign up form
  def new
    @user = User.new
  end

  # show all of the users
  def index
    @users = User.paginate(page: params[:page])
  end

  # update user data
  def update
    @user = User.find_by(id: params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile updated'
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  # find user and render the edit form
  def edit
    @user = User.find_by(id: params[:id])
  end

  # find user and render the profile
  def show
    @user = User.find_by(id: params[:id])
  end

  # create new instance of user and save to the DB
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the sample app!"
      redirect_to user_path(@user.id)
    else
      render :new
    end
  end

  # find user and delete from DB
  def destroy
    User.find_by(id: params[:id]).destroy
    flash[:success] = 'Deleted'
    redirect_to action: 'index', page: "#{params[:page]}"
  end

  private
    # safe params for user form submission
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end 

    # before action filter 
    def ensure_logged_in
      unless logged_in?
        store_location
        flash[:danger] = "Please log in"
        redirect_to login_url 
      end
    end

    # before action filter 
    def ensure_correct_user
      @user = User.find_by(id: params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # before action filter 
    def ensure_admin
      redirect_to root_url unless current_user.admin?
    end
end
