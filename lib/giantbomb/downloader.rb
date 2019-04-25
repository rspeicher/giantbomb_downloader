# frozen_string_literal: true

module GiantBomb
  class Downloader
    DOWNLOAD_TARGET = :hd_url

    def self.execute(since = nil)
      new.execute(since)
    end

    def execute(since = nil)
      videos = GiantBomb::Client.videos(since)
      filtered = GiantBomb::VideoFilter.filter(videos)

      filtered.each do |video|
        download(video)
      end
    end

    def download(video)
      command = %W[
        wget
        --user-agent="#{GiantBomb::Client.user_agent}"
        "#{video.send(DOWNLOAD_TARGET)}?api_key=#{GiantBomb::Client.api_key}"
        -O "#{destination(video)}"
      ]

      system(command.join(' '))
    end

    private

    def destination(video)
      destination = GiantBomb::Config.config['destination']

      destination.gsub(/{{(?<template>[^}]+)}}/) do
        substitute(video, $~[:template].to_sym)
      end
    end

    def substitute(video, attribute)
      case attribute
      when :extension
        File.extname(File.basename(video.send(DOWNLOAD_TARGET)))
      when :filename
        File.basename(video.send(DOWNLOAD_TARGET))
      when :name, :title
        video.name.tr('/', '-')
      else
        video.public_send(attribute)
      end
    end
  end
end
