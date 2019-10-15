namespace :bundle do
  desc 'Extract and validate a bundle archive'
  task :process, [:input, :output] => :environment do |t, args|
    require 'zip'
    # require 'json'
    path = args.input
    bundle = false
    # check size of archive here
    Zip::File.open(path) do |archive|
      info = File.file?('info.data') ? archive.read('info.dat') : nil
      bundle = Bundle.new(info) if info
    end

    if bundle
      bundle.validate
    else
      raise 'Could not find info.dat'
    end
  end

  class Bundle
    attr_accessor :name, :sub_name, :song_author, :level_author, :bpm
    attr_accessor :file_name, :cover_image, :difficulties, :contributors
    attr_accessor :errors

    def initialize(info)
      data = JSON.parse(info) rescue nil
      raise 'info.dat contains invalid JSON' unless @data
      @name = data['_songName']
      @sub_name = data['_songSubName']
      @song_author = data['_songAuthorName']
      @level_author = data['_levelAuthorName']
      @bpm = data['_beatsPerMinute']
      @file_name = data['_songFilename']
      @cover_image = data['_coverImageFilename']
      contributors = data.dig('_customData', '_contributors') || []
      @contributors = contributors.map { |c| Contributor.new(c) }
      difficulties = data.dig('_difficultyBeatmapSets') || []
      @difficulties = difficulties.map { |d| Difficulty.new(d) }
    end

    def validate

    end
  end

  class Difficulty
    attr_accessor :name, :rank, :file_name

    def initialize(data)
    end
  end

  class Contributor
    attr_accessor :name, :role, :icon

    def initialize(data)
    end
  end
end
