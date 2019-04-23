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

    def self.videos(since = nil)
      new.videos(since)
    end

    def videos(since = nil)
      unless since.nil?
        params = {
          filter: "publish_date:#{since.iso8601}|#{Time.now.iso8601}"
        }
      end

      client.get('videos/', params || {})
    end

    private

    def client_config
      {
        url: ENDPOINT,
        params: {
          api_key: ENV.fetch('GIANTBOMB_TOKEN'),
          format: 'json'
        },
        headers: {
          'User-Agent' => 'GiantBomb Downloader -- rspeicher@gmail.com'
        },
        request: {
          params_encoder: ParamsEncoder,
          timeout: 30
        }
      }
    end

    def client
      @client ||= Faraday.new(**client_config) do |config|
        config.response :logger, nil, { headers: false }
        config.response :json

        config.request :json

        config.adapter Faraday.default_adapter
      end
    end
  end
end
