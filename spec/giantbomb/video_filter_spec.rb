# frozen_string_literal: true

require 'spec_helper'

describe GiantBomb::VideoFilter do
  describe '.rejected?' do
    it 'excludes a filtered video name' do
      video = double(name: "Breakfast 'N' Ben - 04/17/19")

      expect(described_class.rejected?(video)).to eq true
    end

    it 'includes an unfiltered video name' do
      video = double(name: "Unprofessional Fridays: 03/15/2019")

      expect(described_class.rejected?(video)).to eq false
    end
  end
end
