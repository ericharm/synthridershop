class AddBundleIdToContributions < ActiveRecord::Migration[5.2]
  def change
    add_column :contributions, :bundle_id, :integer, null: false, references: [:bundles, :id]
  end
end
