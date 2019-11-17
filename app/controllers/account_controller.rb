class AccountController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @newest_sub = @user.newest_sub
    @plans = Plan.all
  end
end
