class CreateSongCharacteristics < ActiveRecord::Migration[5.2]
  def change
    create_table :song_characteristics do |t|
      t.integer :bundle_id, :null => false, :references => [:bundles, :id]
      t.integer :characteristic_id, :null => false, :references => [:characteristics, :id]
      t.timestamps
    end
  end
end
