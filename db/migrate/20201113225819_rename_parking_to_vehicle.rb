class RenameParkingToVehicle < ActiveRecord::Migration[6.0]
  def change
    rename_table :parkings, :vehicles
  end
end
