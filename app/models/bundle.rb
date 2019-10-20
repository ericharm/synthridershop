class Bundle < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :song_difficulties, dependent: :destroy
  has_many :difficulties, through: :song_difficulties
  has_many :contributions, dependent: :destroy
  has_many :contributors, through: :contributions

  mount_base64_uploader :archive, ArchiveUploader
  mount_base64_uploader :thumbnail, ThumbnailUploader

  after_destroy :delete_linked_files

  def delete_linked_files
    self.remove_archive!
    self.remove_thumbnail!
  end
end
