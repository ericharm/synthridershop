module ExtractBundle
  class ExtractBundle
    require 'zip/zip'

    MAXIMUM_UPLOAD_SIZE = 20 * 1_000_000 # 20MB

    attr_reader :cover_image

    def initialize(archive)
      @tempfile = archive.tempfile
      @size = File.size(@tempfile)
      raise UploadError, 'Archive exceeds maximum upload size' if @size > MAXIMUM_UPLOAD_SIZE
      Zip::File.open(@tempfile) do |a|
        @archive = a
      end
      self
    end

    def validate_archive
      info = @archive.read('info.dat') rescue false
      raise UploadError, 'Archive missing info.dat' unless info
      data = JSON.parse(info) rescue false
      raise UploadError, 'info.dat contains invalid JSON' unless data
      @name = data['_songName']
      @sub_name = data['_songSubName']
      @song_author = data['_songAuthorName']
      @level_author = data['_levelAuthorName']
      @bpm = data['_beatsPerMinute']
      @song = data['_songFilename']
      @cover_image = data['_coverImageFilename']
      contributors = data.dig('_customData', '_contributors') || []
      @contributors = contributors.map { |c| ContributorInfo.new(c, @archive) }
      sets = data['_difficultyBeatmapSets'] || []
      @difficulties = sets.reduce([]) do |memo, s|
        defined = s['_difficultyBeatmaps'] || []
        memo.concat(defined.map { |d| DifficultyInfo.new(d, @archive) })
      end
      raise UploadError, 'Missing cover image' unless cover_image_exists
      raise UploadError, 'Missing or invalid song file' unless has_valid_song
    end

    def bundle_params
      mime = MIME::Types.type_for(@cover_image).first.content_type
      prefix = "data:#{mime};base64,"
      thumbnail = Base64.encode64(@archive.read(@cover_image))
      { artist: @song_author, bpm: @bpm, thumbnail: "#{prefix}#{thumbnail}" }
    end

    def create_contributions(bundle)
      bundle.contributions.each { |c| c.destroy }
      @contributors.each do |contributor|
        if contributor.name && contributor.role
          contributor_record = Contributor.find_or_create_by(name: contributor.name) do |c|
            # c.icon =  contributor.icon # update if different
            user = User.find_by(username: contributor.name)
            c.user_id = user ? user.id : nil
          end
          role = ContributorRole.find_or_create_by(title: contributor.role)
          Contribution.create(role_id: role.id, bundle_id: bundle.id, contributor_id: contributor_record.id)
        end
      end
    end

    def create_difficulties(bundle)
      bundle.song_difficulties.each { |d| d.destroy }
      @difficulties.each do |d|
        if d.name
          difficulty = Difficulty.find_or_create_by(name: d.name)
          SongDifficulty.find_or_create_by(difficulty_id: difficulty.id, bundle_id: bundle.id)
        end
      end
    end

    def display
      logger = Rails.logger
      properties = [
        @name, @sub_name, @song_author, @level_author, @bpm, @song, @cover_image,
        @difficulties, @contributors
      ]

      properties.each do |p|
        as_string = send(p)
        logger.info "\n#{p}: "
        logger.info "" if as_string.kind_of?(Array)
        logger.info as_string
      end
    end

    private

    def cover_image_exists
      # must also validate mime type and dimensions
      @archive.read(@cover_image) rescue false
      @cover_image
    end

    def has_valid_song
      @archive.read(@song) rescue false
      @song && @song.match(/\.egg$/)
    end
  end

  class DifficultyInfo
    attr_reader :archive
    attr_accessor :name, :rank, :file

    def initialize(data, archive)
      @archive = archive
      @name = data['_difficulty'] || data['difficulty']
      @rank = data['_difficultyRank'] || data['difficultyRank']
      @file = data['_beatmapFilename'] || data['beatmapFilename']
      raise UploadError, "Invalid difficulty descriptor for #{@name}" unless has_valid_descriptor
    end

    def to_s
      "  #{@name} (#{@file})"
    end

    def has_valid_descriptor
      descriptor = @archive.read(@file) rescue false
      JSON.parse(descriptor) rescue false
      @file
    end
  end

  class ContributorInfo
    attr_reader :archive
    attr_accessor :name, :role, :icon

    def initialize(data, archive)
      @archive = archive
      @name = data['_name'] || data['name']
      @role = data['_role'] || data['role']
      @icon = data['_iconPath'] || data['iconPath']
      raise UploadError, "Invalid contributor icon for #{@name}" if @icon && !has_valid_icon
    end

    def to_s
      "  #{@name} / #{@role} / #{@icon}"
    end

    def has_valid_icon
      # must also validate mime type
      @archive.read(@icon) rescue false
    end
  end
end
