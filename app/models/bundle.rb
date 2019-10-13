class Bundle < ApplicationRecord
  belongs_to :author, class_name: 'User'

  mount_base64_uploader :archive, ArchiveUploader
  mount_base64_uploader :thumbnail, ThumbnailUploader

  after_destroy :delete_linked_files

  def delete_linked_files
    self.remove_archive!
    self.remove_thumbnail!
  end
end
