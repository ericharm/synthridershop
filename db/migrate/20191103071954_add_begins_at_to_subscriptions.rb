class AddBeginsAtToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :begins_at, :datetime
  end
end
