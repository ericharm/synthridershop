class PagesController < ApplicationController
  # before_action :authorize

  def show
    page = params[:page]
    # connect_user if page == 'home'
    render template: "pages/#{page}"
  end

end
