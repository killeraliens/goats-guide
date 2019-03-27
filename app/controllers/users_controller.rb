class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :find_user, only: %i[show edit update]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def update
    @user.update(user_params)
    if @user.save
      redirect_to user_path(@user), notice: "Updated profile."
    else
      render :show, notice: "Couldn't save."
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :photo, :country, :city, :state)
  end
end
