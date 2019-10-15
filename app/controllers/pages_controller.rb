class PagesController < ApplicationController

  def show
    page = params[:page]
    render template: "pages/#{page}"
  end

end
