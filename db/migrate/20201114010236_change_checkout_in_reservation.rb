class ChangeCheckoutInReservation < ActiveRecord::Migration[6.0]
  def change
    change_column :reservations, :checkout, :datetime, null: true
  end
end
