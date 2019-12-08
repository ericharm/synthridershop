class AddGameToBundles < ActiveRecord::Migration[5.2]
  def change
    add_column :bundles, :game, :string
  end
end
