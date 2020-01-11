class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    # Commented out code ensures that users cant modify the url to access someone elses profile. Im not that far along in the tutorial though. Im curious to see how Hartle does this. 
    # if !logged_in? 
      # render plain: "please login!"
    # elsif current_user.id != params[:id].to_i
      # render plain: "cant do that!"
    # else
      @user = User.find_by(id: params[:id])
    # end
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
end
