# frozen_string_literal: true

module GiantBomb
  class Config
    def self.config
      @config ||= YAML.safe_load(
        File.read(File.expand_path('../../config/videos.yml', __dir__))
      )
    end
  end
end
