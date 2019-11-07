class AddPaymentIdToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :payment_id, :string
  end
end
