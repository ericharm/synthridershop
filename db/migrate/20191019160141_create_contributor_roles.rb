class CreateContributorRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :contributor_roles do |t|
      t.string :title
      t.timestamps
    end
  end
end
