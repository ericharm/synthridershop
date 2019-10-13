class AddDetailsToBundles < ActiveRecord::Migration[5.2]
  def change
    add_column :bundles, :artist, :string
    add_column :bundles, :title, :string
    add_column :bundles, :difficulties, :string
    add_column :bundles, :public, :boolean
    add_column :bundles, :thumbnail, :string 
  end
end
