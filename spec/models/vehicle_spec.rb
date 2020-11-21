require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe 'check associations' do
    it { is_expected.to have_many(:reservations).dependent(:destroy) }
  end

  describe 'check types' do
    it { is_expected.to have_db_column(:plate).of_type(:string) }
  end

  describe 'check validations' do
    let(:vehicle) { build_stubbed(:vehicle, plate: nil) }

    it 'must return error' do
      vehicle.validate

      expect(vehicle.errors.full_messages).to include('Plate with invalid format')
    end
  end
end
