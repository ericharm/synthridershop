class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find_by_username(params[:username])
    @is_current = @user.id == current_user.id
    @bundles = @user.visible_bundles(current_user.id)
    @heading = @is_current ? 'Your uploads' : "#{@user.username}'s uploads"
    # maybe a 404 is more sensible here, or a toast
    redirect_to root_path unless @user
  end

  def account
    @user = current_user
    @newest_sub = @user.newest_sub
    @plans = Plan.all
  end
end
