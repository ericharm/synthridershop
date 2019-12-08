class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable
  has_many :bundles, foreign_key: 'author_id', dependent: :destroy
  has_many :subscriptions
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

  def visible_bundles(current_user_id)
    current_user_id == self.id ? self.bundles : self.bundles.where.not(approved_at: nil)
  end

  def subscribed?
    subscriptions.where('expires_at > ?', Time.now).length > 0
  end

  def can_download?
    # probably need to expand this, an unsubscribed user
    # should probably be allowed to download their own maps
    authorized_to_approve? || subscribed?
  end

  def newest_sub
    subscriptions.order(expires_at: :desc).first || nil
  end

  def has_uploaded_maps?
    bundles.count > 0
  end

  def authorized_to_edit?(bundle)
    if is_admin
      return true
    elsif bundle.author_id == id && !bundle.approved_at
      return true
    end
    false
  end

  def authorized_to_approve?
    (is_admin || is_approver) || false
  end

  def requires_subscription?
    !subscribed? && !is_admin && !is_approver
  end
end
