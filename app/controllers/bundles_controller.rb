class BundlesController < ApplicationController
  before_action :authenticate_user!

  def index
    # @bundles = Bundle.where(public: true) # eventually must paginate
    @bundles =  Bundle.where(public: true).joins(:author).preload(:author)
  end

  def new
    @bundle = Bundle.new
  end

  def create
    bundle = current_user.bundles.create(bundle_params)
    if bundle 
      redirect_to action: 'index'
    else
      redirect_to action: 'index'
    end
  end

  def show
    @bundle = Bundle.find(params[:id])
    redirect_to action: 'index' unless @bundle
  end

  def edit
    @bundle = current_user.bundles.find(params[:id])
  end

  def update
    bundle = current_user.bundles.find(params[:id])
    if bundle && bundle.update(bundle_params)
      flash[:notice] = "#{bundle.title} has been updated"
      redirect_to action: 'index'
    else
      flash[:alert] = "#{bundle.title} could not be updated"
      redirect_to action: 'index'
    end
  end

  def destroy
    bundles = current_user.bundles
    bundle = bundles.find(params[:id])
    if bundle 
      title = bundle.title
      bundle.destroy
      flash[:notice] = "#{title} was deleted"
    else
      flash[:alert] = "#{title} could not be deleted"
    end
    redirect_to action: 'index'
  end

  private

  def bundle_params
    params.require(:bundle).permit(
      :title, :artist, :difficulties, :thumbnail, :archive, :public, :user_id
    )
  end

end
