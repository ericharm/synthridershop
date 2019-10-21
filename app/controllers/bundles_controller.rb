class BundlesController < ApplicationController
  before_action :authenticate_user!

  def index
    @bundles =  Bundle.where(public: true).joins(:author).preload(:author)
  end

  def new
    @bundle = Bundle.new
  end

  def create
    archive = bundle_params[:archive]
    begin
      extractor = ExtractBundle::ExtractBundle.new(archive)
      extractor.validate_archive
      bundle = current_user.bundles.create(bundle_params.merge(extractor.bundle_params))
      extractor.create_contributions(bundle)
      extractor.create_difficulties(bundle)
      flash[:notice] = "#{bundle.title} has been created"
    rescue StandardError => e
      # clean up all the records here
      flash[:alert] = e
    end
    redirect_to action: 'index'
  end

  def show
    @bundle = Bundle.joins('left join users on users.id = bundles.author_id')
      .select('bundles.*', 'users.username as author_name')
      .includes(:contributions => [:contributor, :role])
      .includes(:difficulties).find(params[:id])
    redirect_to action: 'index' unless @bundle
    visible = @bundle.public || @bundle.author_id == current_user.id
    redirect_to action: 'index' unless visible
    @contributors = @bundle.contributions.reduce({}) do |memo, c|
      memo[c.contributor.name] = memo[c.contributor.name] || []
      memo[c.contributor.name] << c.role.title
      memo
    end
  end

  def edit
    @bundle = current_user.bundles.find(params[:id])
  end

  def update
    bundle = current_user.bundles.find(params[:id])
    if bundle && bundle.update(bundle_params)
      flash[:notice] = "#{bundle.title} has been updated"
    else
      flash[:alert] = "#{bundle.title} could not be updated"
    end
    redirect_to action: 'index'
  end

  def destroy
    bundle = current_user.bundles.find(params[:id])
    title = bundle ? bundle.title : 'Your custom map'
    if bundle && bundle.destroy
      flash[:notice] = "#{title} was deleted"
    else
      flash[:alert] = "#{title} could not be deleted"
    end
    redirect_to action: 'index'
  end

  private

  def bundle_params
    params.require(:bundle).permit(
      :title, :description, :archive, :public, :user_id
    )
  end

end
