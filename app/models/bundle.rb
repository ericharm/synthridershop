class Bundle < ApplicationRecord
  belongs_to :author, class_name: 'User'

  mount_base64_uploader :archive, ArchiveUploader
  after_destroy :delete_linked_file

  def delete_linked_file
    self.remove_archive!
  end
end
