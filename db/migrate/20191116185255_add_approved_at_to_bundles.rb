class AddApprovedAtToBundles < ActiveRecord::Migration[5.2]
  def change
    remove_column :bundles, :is_approved
    add_column :bundles, :approved_at, :datetime
  end
end
