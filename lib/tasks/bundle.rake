namespace :bundle do
  desc 'Extract and validate a bundle archive'
  task :process, [:input] => :environment do |t, args|
    path = args.input
    bundle = Bundle.new(path)
    bundle.display
    # if we got this far, create the records
  end

  class Bundle
    require 'zip'
    MAXIMUM_UPLOAD_SIZE = 20 * 1_000_000 # 20MB
    attr_reader :archive, :size
    attr_accessor :name, :sub_name, :song_author, :level_author, :bpm
    attr_accessor :song, :cover_image, :difficulties, :contributors

    def initialize(path)
      @size = File.size(path)
      raise 'Archive exceeds maximum upload size' if @size > MAXIMUM_UPLOAD_SIZE
      Zip::File.open(path) do |archive|
        validate_archive(archive)
      end
    end

    def validate_archive(archive)
      @archive = archive
      info = archive.read('info.dat') rescue false
      raise 'Archive missing info.dat' unless info
      data = JSON.parse(info) rescue false
      raise 'info.dat contains invalid JSON' unless data
      @name = data['_songName']
      @sub_name = data['_songSubName']
      @song_author = data['_songAuthorName']
      @level_author = data['_levelAuthorName']
      @bpm = data['_beatsPerMinute']
      @song = data['_songFilename']
      @cover_image = data['_coverImageFilename']
      contributors = data.dig('_customData', '_contributors') || []
      @contributors = contributors.map { |c| Contributor.new(c, archive) }
      sets = data['_difficultyBeatmapSets'] || []
      @difficulties = sets.reduce([]) do |memo, s|
        defined = s['_difficultyBeatmaps'] || []
        memo.concat(defined.map { |d| Difficulty.new(d, archive) })
      end
      raise 'Missing cover image' unless cover_image_exists
      raise 'Missing or invalid song file' unless has_valid_song
    end

    def cover_image_exists
      # must also validate mime type and dimensions
      @archive.read(@cover_image) rescue false
      @cover_image
    end

    def has_valid_song
      @archive.read(@song) rescue false
      @song && @song.match(/\.egg$/)
    end

    def display
      o = Object.new
      unique_setters = public_methods.select do |m|
        o.public_methods.exclude?(m) && m.match(/\w=$/)
      end

      properties = unique_setters.map { |p| p.to_s[0...-1].to_sym }

      properties.each do |p|
        as_string = send(p)
        print "\n#{p}: "
        puts "" if as_string.kind_of?(Array)
        puts as_string
      end

      def save
        # create database records, creating memos along the way
        # if any transaction fails, roll all transactions back
      end
    end
  end

  class Difficulty
    attr_reader :archive
    attr_accessor :name, :rank, :file

    def initialize(data, archive)
      @archive = archive
      @name = data['_difficulty']
      @rank = data['_difficultyRank']
      @file = data['_beatmapFilename']
      raise "Invalid difficulty descriptor for #{@name}" unless has_valid_descriptor
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

  class Contributor
    attr_reader :archive
    attr_accessor :name, :role, :icon

    def initialize(data, archive)
      @archive = archive
      @name = data['_name']
      @role = data['_role']
      @icon = data['_iconPath']
      raise "Invalid contributor icon for #{@name}" if @icon && !has_valid_icon
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
