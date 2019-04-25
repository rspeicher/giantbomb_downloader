# frozen_string_literal: true

require 'yaml'

module GiantBomb
  class VideoFilter
    def self.config
      GiantBomb::Config.config
    end

    def self.filter(videos)
      videos.select do |video|
        if rejected?(video)
          $stderr.puts "- #{video.name}"
          false
        else
          $stdout.puts "+ #{video.name}"
          true
        end
      end
    end

    def self.rejected?(video)
      config['reject'].any? do |field, options|
        options.any? do |value|
          video.respond_to?(field) && video.public_send(field)&.include?(value)
        end
      end
    end
  end
end
