class CreateSongDifficulties < ActiveRecord::Migration[5.2]
  def change
    create_table :song_difficulties do |t|
      t.integer :bundle_id, :null => false, :references => [:bundles, :id]
      t.integer :difficulty_id, :null => false, :references => [:difficulties, :id]
      t.timestamps
    end
  end
end
