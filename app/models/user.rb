class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable
  has_many :bundles, foreign_key: 'author_id', dependent: :destroy
  has_many :subscriptions
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

  def visible_bundles(current_user_id)
    current_user_id == self.id ? self.bundles : self.bundles.where(public: true)
  end

  def subscribed?
    subscriptions.where('expires_at > ?', Time.now).length > 0
  end

  def newest_sub
    subscriptions.order(expires_at: :desc).first || nil
  end

  def authorized_to_approve?
    # oops please rename these columns is_admin and is_approver
    (admin || approver) || false
  end
end
