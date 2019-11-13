class AddAdminApproverStatusToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admin, :boolean
    add_column :users, :approver, :boolean
  end
end
