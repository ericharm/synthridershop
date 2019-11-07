class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.integer :plan_id
      t.integer :user_id, :references => [:users, :id]
      t.datetime :expires_at
      t.timestamps
    end
  end
end
