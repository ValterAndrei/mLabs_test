class CreateReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :reservations do |t|
      t.datetime :checkin, precision: 6, null: false
      t.datetime :checkout, precision: 6, null: false
      t.boolean :paid, default: false
      t.boolean :left, default: false
      t.string :code, null: false
      t.references :vehicle, foreign_key: true

      t.timestamps
    end
  end
end
