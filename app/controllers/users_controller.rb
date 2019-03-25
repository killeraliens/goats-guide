class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.photo = params[:user][:photo]
    if @user.save
      redirect_to user_path(@user), notice: "Updated profile."
    else
      render :show, notice: "Couldn't save."
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :photo)
  end
end
