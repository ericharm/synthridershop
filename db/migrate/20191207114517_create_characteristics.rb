class CreateCharacteristics < ActiveRecord::Migration[5.2]
  def change
    create_table :characteristics do |t|
      t.string :name
      t.timestamps
    end
  end
end
