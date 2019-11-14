class ChangeRoleColumnNames < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :admin, :is_admin
    rename_column :users, :approver, :is_approver
    rename_column :bundles, :public, :is_approved
  end
end
