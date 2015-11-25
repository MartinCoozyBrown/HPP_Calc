class CreateHourlyRates < ActiveRecord::Migration
  def change
    create_table :hourly_rates do |t|
      t.date :date
      t.time :time
      t.float :rate

      t.timestamps null: false
    end
  end
end
