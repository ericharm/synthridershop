class SearchController < ApplicationController
  before_action :authenticate_user!

  def create
    # sanitize this
    query = params['query']
    redirect_to controller: 'bundles', action: 'index', query: query
  end
end

