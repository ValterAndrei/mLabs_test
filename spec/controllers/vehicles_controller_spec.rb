require 'rails_helper'

RSpec.describe VehiclesController, type: :request do
  describe 'GET #index' do
    let!(:vehicle) { create(:vehicle) }

    before { get '/' }

    it 'returns http success' do
      expect(response).to be_successful
    end

    it 'returns all vehicles' do
      expect(response.body).not_to be_empty
      expect(JSON.parse(response.body)).to eq(
        [
          { 'plate' => vehicle.plate, 'reservations' => [] }
        ]
      )
    end
  end

  describe 'GET #show' do
    context 'when vehicle exists' do
      let!(:vehicle) { create(:vehicle) }

      before { get "/parking/#{vehicle.plate}" }

      it 'returns http success' do
        expect(response).to be_successful
      end

      it 'returns vehicles info' do
        expect(response.body).not_to be_empty
        expect(JSON.parse(response.body)).to eq(
          { 'plate' => vehicle.plate, 'reservations' => [] }
        )
      end
    end

    context 'when vehicle doesn\'t exists' do
      before { get '/parking/xxx' }

      it 'returns http not found' do
        expect(response).to be_not_found
      end

      it 'returns alert message' do
        expect(response.body).not_to be_empty
        expect(JSON.parse(response.body)).to eq(
          { 'message' => 'Vehicle not found' }
        )
      end
    end
  end

  describe 'POST #create' do
    context 'when is a invalid plate' do
      subject { post '/parking/', params: { vehicle: { plate: 'XXX' } } }

      it 'don\'t creates a new vehicle or reservation' do
        expect { subject }.to change(Vehicle, :count).by(0)
                                                     .and(change(Reservation, :count).by(0))
      end

      it 'returns http unprocessable' do
        subject

        expect(response).to be_unprocessable
      end

      it 'returns alert message' do
        subject

        expect(response.body).not_to be_empty
        expect(JSON.parse(response.body)).to eq(
          { 'message' => 'Validation failed: Plate with invalid format' }
        )
      end
    end

    context 'when is a new vehicle' do
      subject { post '/parking/', params: { vehicle: { plate: 'XXX-2457' } } }

      it 'creates a new vehicle and a reservation' do
        expect { subject }.to change(Vehicle, :count).by(1)
                                                     .and(change(Reservation, :count).by(1))
      end

      it 'returns http success' do
        subject

        expect(response).to be_successful
      end

      it 'returns reservations code' do
        subject

        expect(response.body).not_to be_empty
        expect(JSON.parse(response.body)).to eq(
          { 'code' => Reservation.last.code }
        )
      end
    end

    context 'when vehicle already exists without reservations' do
      let!(:vehicle) { create(:vehicle) }

      subject do
        post '/parking/', params: { vehicle: { plate: vehicle.plate } }
      end

      it 'creates a new reservation' do
        expect { subject }.to change(Vehicle, :count).by(0)
                                                     .and(change(Reservation, :count).by(1))
      end

      it 'returns http success' do
        subject

        expect(response).to be_successful
      end

      it 'returns reservations code' do
        subject

        expect(response.body).not_to be_empty
        expect(JSON.parse(response.body)).to eq(
          { 'code' => Reservation.last.code }
        )
      end
    end

    context 'when vehicle already exists with open reservations' do
      let!(:vehicle) { create(:vehicle) }
      let!(:reservation) { create(:reservation, vehicle: vehicle) }

      subject do
        post '/parking/', params: { vehicle: { plate: vehicle.plate } }
      end

      it 'don\'t creates a new vehicle or reservation' do
        expect { subject }.to change(Vehicle, :count).by(0)
                                                     .and(change(Reservation, :count).by(0))
      end

      it 'returns http unprocessable' do
        subject

        expect(response).to be_unprocessable
      end

      it 'returns alert message' do
        subject

        expect(response.body).not_to be_empty
        expect(JSON.parse(response.body)).to eq(
          ['Vehicle still in the parking lot']
        )
      end
    end
  end

  describe 'PUT #pay' do
    context 'when vehicle don\'t exists' do
      subject { put '/parking/XXX/pay' }

      it 'returns http not found' do
        subject

        expect(response).to be_not_found
      end

      it 'returns alert message' do
        subject

        expect(response.body).not_to be_empty
        expect(JSON.parse(response.body)).to eq(
          { 'message' => 'Reservation not fount' }
        )
      end
    end

    context 'when reservation already exists' do
      let!(:vehicle) { create(:vehicle) }
      let!(:reservation) { create(:reservation, vehicle: vehicle) }

      subject { put "/parking/#{reservation.code}/pay" }

      it 'returns http success' do
        subject

        expect(response).to be_successful
      end

      it 'returns reservation code' do
        subject

        expect(response.body).not_to be_empty
        expect(JSON.parse(response.body)).to eq(
          { 'code' => Reservation.last.code }
        )
      end
    end

    context 'when reservation is invalid' do
      let!(:vehicle) { create(:vehicle) }
      let!(:reservation) { create(:reservation, vehicle: vehicle) }

      before do
        allow_any_instance_of(Reservation).to receive(:save).and_return(false)
      end

      subject { put "/parking/#{reservation.code}/pay" }

      it 'returns http unprocessable' do
        subject

        expect(response).to be_unprocessable
      end

      it 'returns empty info' do
        subject

        expect(response.body).not_to be_empty
        expect(JSON.parse(response.body)).to eq([])
      end
    end
  end

  describe 'PUT #out' do
    context 'when vehicle don\'t exists' do
      subject { put '/parking/XXX/out' }

      it 'returns http not found' do
        subject

        expect(response).to be_not_found
      end

      it 'returns alert message' do
        subject

        expect(response.body).not_to be_empty
        expect(JSON.parse(response.body)).to eq(
          { 'message' => 'Reservation not fount' }
        )
      end
    end

    context 'when the reservation is not paid' do
      let!(:vehicle) { create(:vehicle) }
      let!(:reservation) { create(:reservation, vehicle: vehicle) }

      subject { put "/parking/#{reservation.code}/out" }

      it 'returns http unprocessable' do
        subject

        expect(response).to be_unprocessable
      end

      it 'returns alert message' do
        subject

        expect(response.body).not_to be_empty
        expect(JSON.parse(response.body)).to eq(['Reservation payment not yet made'])
      end
    end

    context 'when the reservation is already paid' do
      let!(:vehicle) { create(:vehicle) }
      let!(:reservation) { create(:reservation, vehicle: vehicle, paid: true) }

      subject { put "/parking/#{reservation.code}/out" }

      it 'returns http success' do
        subject

        expect(response).to be_successful
      end

      it 'returns reservation code' do
        subject

        expect(response.body).not_to be_empty
        expect(JSON.parse(response.body)).to eq(
          { 'code' => Reservation.last.code }
        )
      end
    end
  end
end
