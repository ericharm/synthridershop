class CreateContributors < ActiveRecord::Migration[5.2]
  def change
    create_table :contributors do |t|
      t.string :name
      t.string :icon
      t.integer :user_id, :references => [:users, :id]
      t.timestamps
    end
  end
end
