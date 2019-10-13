class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :bundles, foreign_key: 'author_id'

  def visible_bundles(current_user_id)
    current_user_id == self.id ? self.bundles : self.bundles.where(public: true)
  end
end
