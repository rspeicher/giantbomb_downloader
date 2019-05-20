# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'

module GiantBomb
  module ParamsEncoder
    extend self

    def encode(hash)
      # The GiantBomb API does _not_ handle encoded values correctly
      Faraday::NestedParamsEncoder.encode(hash)
        .gsub('%3A', ':')
        .gsub('%2B', '+')
    end

    def decode(string)
      Faraday::NestedParamsEncoder.decode(string)
    end
  end

  class Client
    ENDPOINT = 'https://www.giantbomb.com/api/'

    def self.api_key
      ENV.fetch('GIANTBOMB_TOKEN')
    end

    def self.user_agent
      'GiantBomb Downloader -- rspeicher@gmail.com'
    end

    def self.search(query)
      new.search(query)
    end

    def self.videos(last_run = nil)
      new.videos(last_run)
    end

    def search(query)
      client
        .get('search/', { query: query, resources: 'video' })
        .body['results']
        .map { |v| GiantBomb::Video.new(v) }
    rescue Faraday::ConnectionFailed
      # no-op
    end

    def videos(last_run = nil)
      params = {
        sort: 'publish_date:asc'
      }

      unless last_run.nil?
        params.merge!(
          # NOTE: The date filter requires an "end date" value
          filter: "publish_date:#{last_run.iso8601}|#{Time.now.iso8601}",
        )
      end

      # TODO (rspeicher): Error handling?
      client
        .get('videos/', params || {})
        .body['results']
        .map { |v| GiantBomb::Video.new(v) }
    end

    private

    def client_config
      {
        url: ENDPOINT,
        params: {
          api_key: self.class.api_key,
          format: 'json'
        },
        headers: {
          'User-Agent' => self.class.user_agent
        },
        request: {
          params_encoder: ParamsEncoder,
          timeout: 30
        }
      }
    end

    def client
      @client ||= Faraday.new(**client_config) do |config|
        config.response :logger, nil, { headers: false } do |logger|
          logger.filter(self.class.api_key, '[key]')
        end

        config.response :json
        config.request  :json

        config.adapter Faraday.default_adapter
      end
    end
  end
end
