require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let!(:reservation) { create(:reservation) }

  describe 'check associations' do
    it { expect(reservation).to belong_to(:vehicle) }
  end

  describe 'validate presence fields' do
    it { expect(reservation).to validate_presence_of(:checkin) }
    it { expect(reservation.paid).to be_in([true, false]) }
    it { expect(reservation.left).to be_in([true, false]) }
  end

  describe '.time' do
    let(:reservation) { build_stubbed(:reservation, checkout: Time.zone.now) }

    it 'return correct time' do
      expect(reservation.time).to eq(
        ActiveSupport::Duration.build(reservation.checkout - reservation.checkin).inspect
      )
    end
  end

  describe 'check validations' do
    context 'when the vehicle is still parked' do
      let(:vehicle) { create(:vehicle) }
      let(:reservation) { create(:reservation, vehicle: vehicle) }
      let(:new_reservation) { build(:reservation, vehicle: vehicle) }

      it 'must return error' do
        new_reservation.validate

        expect(new_reservation.errors.full_messages).to include('Vehicle still in the parking lot')
      end
    end

    context 'when the payment not yet made' do
      let(:vehicle) { create(:vehicle) }
      let(:reservation) { create(:reservation, vehicle: vehicle) }

      it 'must return error' do
        reservation.left = true
        reservation.validate

        expect(reservation.errors.full_messages).to include('Reservation payment not yet made')
      end
    end
  end
end
