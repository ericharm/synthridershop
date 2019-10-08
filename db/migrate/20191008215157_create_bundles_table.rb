class CreateBundlesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :bundles do |t|
      t.string :name
      t.string :archive
      t.integer :author_id, :null => false, :references => [:users, :id]
      t.timestamps
    end
  end
end
