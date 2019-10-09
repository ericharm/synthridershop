class BundlesController < ApplicationController
  before_action :authenticate_user!

  def index
    @bundles = current_user.bundles
  end
end
