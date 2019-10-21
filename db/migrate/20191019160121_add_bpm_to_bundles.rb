class AddBpmToBundles < ActiveRecord::Migration[5.2]
  def change
    add_column :bundles, :bpm, :integer
  end
end
