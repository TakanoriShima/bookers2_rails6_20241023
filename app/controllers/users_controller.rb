class UsersController < ApplicationController
  # protect_from_forgery
  # skip_before_action :verify_authenticity_token
  def index
    @users = User.all
    @user = current_user
    @book = Book.new
  end

  def show
    @user = User.find(params[:id])
    if @user.id == current_user.id
      @user = current_user
    end
    @books = @user.books
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
    unless @user.id == current_user.id
      redirect_to current_user
    end  
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'You have updated user successfully.'
      redirect_to current_user
    else
      render :edit
    end
  end
  
  private 
  
  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end
end
