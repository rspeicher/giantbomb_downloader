# frozen_string_literal: true

require 'spec_helper'

describe GiantBomb::Downloader do
  subject(:downloader) { described_class.new }

  describe '#destination' do
    it 'replaces templates with video attributes' do
      video = double(
        guid: '1234-5678',
        name: 'Foo Title',
        filename: 'path/to/filename.mp4',
        hd_url: 'https://example.com/filename.mp4'
      )

      expect(downloader.__send__(:destination, video))
        .to end_with('1234-5678 - Foo Title.mp4')
    end
  end
end
