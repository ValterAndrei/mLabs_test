require 'rails_helper'

RSpec.describe PlateValidator do
  describe '.run' do
    context 'when plate is nil' do
      let(:plate) { nil }
      
      it { expect(described_class.new(plate).run).to be_falsey  }
    end

    context 'when the plate is correctly format' do
      let(:plate) { 'QBT-9377' }
      
      it { expect(described_class.new(plate).run).to be_truthy  }
    end

    context 'when the plate is incorrectly format' do
      let(:plate) { 'QBT-xxxx' }
      
      it { expect(described_class.new(plate).run).to be_falsey  }
    end
  end
end
