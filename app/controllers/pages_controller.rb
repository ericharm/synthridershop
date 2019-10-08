class PagesController < ApplicationController
  # before_action :authorize

  def show
    page = params[:page]
    puts 'current_user'
    puts current_user
    # connect_user if page == 'home'
    render template: "pages/#{page}"
  end

end
