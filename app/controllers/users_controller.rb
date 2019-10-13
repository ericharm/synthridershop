class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @is_current = @user.id == current_user.id
    @bundles = @user.visible_bundles(current_user.id)
    @heading = @is_current ? 'Your uploads' : "#{@user.email}'s uploads"
    redirect_to root_path unless @user # maybe a 404 is more sensible here
  end
end
