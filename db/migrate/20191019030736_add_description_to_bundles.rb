class AddDescriptionToBundles < ActiveRecord::Migration[5.2]
  def change
    add_column :bundles, :description, :text
    remove_column :bundles, :difficulties, :string
  end
end
