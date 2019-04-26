# frozen_string_literal: true

require 'json'

module GiantBomb
  class Config
    def self.config
      @config ||= JSON.parse(File.read(config_file))
    end

    def self.config_file
      File.expand_path('../../config/videos.json', __dir__)
    end
  end
end
