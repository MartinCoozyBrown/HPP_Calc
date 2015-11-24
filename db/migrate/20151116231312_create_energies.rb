class CreateEnergies < ActiveRecord::Migration
  def change
    create_table :energies do |t|
      t.string :energy_data
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
