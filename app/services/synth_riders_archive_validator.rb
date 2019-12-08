module SynthRidersArchiveValidator
  class Validator
    require 'zip/zip'

    MAXIMUM_UPLOAD_SIZE = 20 * 1_000_000 # 20MB

    SUPPORTED_ROLES = {
      'mapper' => 'Mapper'
    }

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
      info = @archive.read('beatmap.meta.bin') rescue false
      raise UploadError, 'Archive missing beatmap.meta.bin' unless info
      # remove the byte order mark from this file
      info.gsub!(/\A[^{]+/, '')
      data = JSON.parse(info) rescue false
      raise UploadError, 'beatmap.meta.bin contains invalid JSON' if data == false
      @name = data['Name']
      @song_author = data['Author']
      @level_author = data['Beatmapper']
      @bpm = data['BPM']
      @song = data['AudioName']
      @cover_image = data['Artwork']
      track = data['Track']
      @difficulties = track.keys.select { |k| track[k].length > 0 }
      raise UploadError, 'Missing cover image' unless cover_image_exists
      raise UploadError, 'Missing or invalid song file' unless has_valid_song
    end

    def bundle_params
      mime = MIME::Types.type_for(@cover_image).first.content_type
      prefix = "data:#{mime};base64,"
      thumbnail = Base64.encode64(@archive.read(@cover_image))
      { artist: @song_author, bpm: @bpm, thumbnail: "#{prefix}#{thumbnail}" }
    end

    def create_difficulties(bundle)
      bundle.song_difficulties.each { |d| d.destroy }
      @difficulties.each do |d|
        if d
          # should each game have its own difficulty records?
          difficulty = Difficulty.find_or_create_by(name: d)
          SongDifficulty.find_or_create_by(difficulty_id: difficulty.id, bundle_id: bundle.id)
        end
      end
    end

    def create_contributions(bundle)
    end

    def create_characteristics(bundle)
    end

    def display
      logger = Rails.logger
      properties = [
        @name, @song_author, @level_author, @bpm, @song, @cover_image, @difficulties
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
      @song && @song.match(/\.ogg$/)
    end
  end
end
