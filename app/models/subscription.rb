class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  before_create do
    last_active_sub = user.subscriptions.order('begins_at').last
    self.begins_at = last_active_sub ? last_active_sub.expires_at : Time.now
    self.expires_at = self.begins_at + self.plan.length
  end

  def expiration_date
    created_at + plan.length
  end
end
