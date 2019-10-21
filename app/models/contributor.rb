class Contributor < ApplicationRecord
  has_many :contributions, dependent: :destroy
end
