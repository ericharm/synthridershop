class Contribution < ApplicationRecord
  belongs_to :contributor
  belongs_to :role, class_name: 'ContributorRole'
end
