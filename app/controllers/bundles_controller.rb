class BundlesController < ApplicationController
  before_action :authenticate_user!

  def index
    @bundles = current_user.bundles
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
      render json: { status: 202, message: 'Success', data: bundle }
    else
      render json: { status: 400, message: 'Error' }
    end
  end

  def destroy
    bundles = current_user.bundles
    bundle = bundles.find(params[:id])
    if bundle 
      name = bundle.name
      bundle.destroy
      flash[:notice] = "#{name} was deleted"
    else
      flash[:alert] = "#{name} could not be deleted"
    end
    redirect_to action: 'index'
  end

  private

  def bundle_params
    params.require(:bundle).permit(:name, :archive, :user_id)
  end

end
