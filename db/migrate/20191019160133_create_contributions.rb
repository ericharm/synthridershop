class CreateContributions < ActiveRecord::Migration[5.2]
  def change
    create_table :contributions do |t|
      t.integer :contributor_id, :null => false, :references => [:contributors, :id]
      t.integer :role_id, :null => false, :references => [:contributor_roles, :id]
      t.timestamps
    end
  end
end
