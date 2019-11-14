class BundlesController < ApplicationController
  before_action :authenticate_user!

  def index
    @bundles = Bundle.where(is_approved: true)
      .joins('left join users on users.id = bundles.author_id')
      .select('bundles.*', 'users.username as author_name')
    @pending = !current_user.authorized_to_approve?  ? []
      : Bundle.where.not(is_approved: true)
        .joins('left join users on users.id = bundles.author_id')
        .select('bundles.*', 'users.username as author_name')
  end

  def new
    @bundle = Bundle.new
  end

  def create
    archive = bundle_params[:archive]
    bundle = extract_archive(archive)
    if bundle
      redirect_to action: 'show', id: bundle.id
    else
      redirect_to action: 'index'
    end
  end

  def show
    @bundle = Bundle.joins('left join users on users.id = bundles.author_id')
      .select('bundles.*', 'users.username as author_name')
      .includes(:contributions => [:contributor, :role])
      .includes(:difficulties).find(params[:id])
    redirect_to action: 'index' unless @bundle
    visible = @bundle.is_approved || @bundle.author_id == current_user.id || current_user.authorized_to_approve?
    redirect_to action: 'index' unless visible
    @contributors = @bundle.contributions.reduce({}) do |memo, c|
      memo[c.contributor.name] = memo[c.contributor.name] || []
      memo[c.contributor.name] << c.role.title
      memo
    end
    @approve_button_text = @bundle.is_approved ? 'Unapprove' : 'Approve'
  end

  def edit
    @bundle = Bundle.find(params[:id])
    redirect_to action: 'index' unless (current_user.authorized_to_edit?(@bundle))
  end

  def update
    bundle = Bundle.find(params[:id])
    if bundle && current_user.authorized_to_edit(bundle)
      archive = bundle_params[:archive]
      if archive
        extract_archive(archive, bundle)
        bundle.update(is_approved: false)
      else
        bundle.update(bundle_params)
      end
    else
      flash[:alert] = "#{bundle.title} could not be updated"
    end
    redirect_to action: 'show', id: bundle.id
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

  def approve
    bundle = Bundle.find(params[:id])
    bundle.update(is_approved: !bundle.is_approved) if current_user.authorized_to_approve?
    redirect_to action: 'show', id: bundle.id
  end

  private


  def extract_archive(archive, bundle = nil)
    success_verb = bundle ? 'updated' : 'created'
    begin
      extractor = ExtractBundle::ExtractBundle.new(archive)
      extractor.validate_archive
      if (bundle)
        bundle.update(bundle_params.merge(extractor.bundle_params))
      else
        bundle = current_user.bundles.create(bundle_params.merge(extractor.bundle_params))
      end
      extractor.create_contributions(bundle)
      extractor.create_difficulties(bundle)
      flash[:notice] = "#{bundle.title} has been #{success_verb}"
    rescue UploadError => e
      flash[:alert] = e
    rescue StandardError => e
      flash[:alert] = e
    end
    return bundle
  end

  def bundle_params
    params.require(:bundle).permit(:title, :description, :archive, :public, :user_id)
  end

end
