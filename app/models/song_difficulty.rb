class SongDifficulty < ApplicationRecord
  belongs_to :bundle
  belongs_to :difficulty
end
