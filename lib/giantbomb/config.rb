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

    def self.state
      @state ||=
        if File.exist?(state_file)
          JSON.parse(File.read(state_file))
        else
          { last_run: Time.now }
        end
    end

    def self.state_file
      File.expand_path('~/.config/giantbomb/state.json')
    end

    def self.write_state(state)
      File.write(state_file, JSON.pretty_generate(state))
    end

    def self.last_run
      Time.parse(state['last_run']) rescue nil
    end

    def self.last_run=(value)
      state['last_run'] = value
      write_state(state)
    end
  end
end
