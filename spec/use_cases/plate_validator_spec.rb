require 'rails_helper'

RSpec.describe PlateValidator do
  let(:plate) { 'BQT-9375' }

  describe '.run' do
    it { expect(described_class.new(plate).run).to be_truthy  }
  end
end
