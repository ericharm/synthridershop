class PagesController < ApplicationController
  # before_action :authorize

  def show
    page = params[:page]
    puts 'ack ack' if user_signed_in?
    # connect_user if page == 'home'
    render template: "pages/#{page}"
  end

end
