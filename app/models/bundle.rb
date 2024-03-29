class Bundle < ApplicationRecord
  include PgSearch::Model
  belongs_to :author, class_name: 'User'
  validates :game, inclusion: { in: ['Beat Saber', 'Synth Riders'] }
  has_many :song_characteristics, dependent: :destroy
  has_many :characteristics, through: :song_characteristics
  has_many :song_difficulties, dependent: :destroy
  has_many :difficulties, through: :song_difficulties
  has_many :contributions, dependent: :destroy
  has_many :contributors, through: :contributions

  mount_base64_uploader :archive, ArchiveUploader
  mount_base64_uploader :thumbnail, ThumbnailUploader

  after_destroy :delete_linked_files

  scope :with_author_name, -> {
    joins('left join users on users.id = bundles.author_id')
      .select('bundles.*', 'users.username as author_name')
  }

  scope :with_author_and_contributors, -> { includes(:contributions).includes(:contributors) }

  pg_search_scope :search, against: [
    [:title, 'A'], [:artist, 'B']
  ], associated_against: {
    contributors: :name,
    author: :username
  }, using: { tsearch: { prefix: true } }

  def delete_linked_files
    self.remove_archive!
    self.remove_thumbnail!
  end

  # we will probably not use the s3 url directly once the bucket is made private
  # rather the server will download it using client.get_obect and encrypt the json
  # such that only the current_user's access key can descramble it
  # this method is just here as a reminder of how to access a private bucket
  def archive_url
    credentials = { aws_access_key_id: ENV['s3_key'], aws_secret_access_key: ENV['s3_secret'] }
    client = Fog::AWS::Storage.new(credentials)
    bucket_name = ENV['s3_bucket']
    client.get_object_url(bucket_name, archive.path, 2.seconds.from_now.to_i)
  end

end
