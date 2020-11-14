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
    let!(:reservation) { create(:reservation, checkout: time_now) }

    context 'when reservation with checkout' do
      let(:time_now) { Time.zone.now + 5.minutes }

      it 'return correct time' do
        expect(reservation.time).to eq(
          ActiveSupport::Duration.build(reservation.checkout - reservation.checkin).inspect
        )
      end
    end

    context 'when reservation without checkout' do
      let(:checkout) { nil }
      let(:time_now) { Time.zone.now }

      it 'return correct time' do
        expect(reservation.time).to eq(
          ActiveSupport::Duration.build(time_now - reservation.checkin).inspect
        )
      end
    end
  end
end
