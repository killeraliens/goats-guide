class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :find_user, only: %i[show edit update]

  def index
    @users = User.all
    params[:query].present? ? @users = User.search_by_username_country_state_city(params[:query]) : @users
  end

  def show
    saved_event_ids = @user.saved_events.map {|event| event.event_id }
    @events = Event.find(saved_event_ids)
  end

  def edit
    @url_link = UrlLink.new(url: params[:url], user_id: params[:id])
  end

  def update
    if params[:url_link].present?
      @url_link = UrlLink.new(url: params[:url_link][:url], link: params[:url_link][:link], user_id: params[:id])
      @url_link.save
    end
    @user.update(user_params) if params[:user].present?
    if @user.save
      redirect_to user_path(@user), notice: "Updated profile."
    else
      render :edit, notice: "Couldn't save."
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :photo, :country, :city, :state, :quote)
  end
end
