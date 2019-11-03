class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  before_create do
    self.expires_at = Time.now + self.plan.length
  end

  def expiration_date
    created_at + plan.length
  end
end
