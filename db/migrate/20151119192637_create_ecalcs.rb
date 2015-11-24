class CreateEcalcs < ActiveRecord::Migration
  def change
    create_table :ecalcs do |t|
      t.integer :user_id
      t.string :type
      t.timestamp :start_time
      t.timestamp :end_time
      t.integer :usage
      t.string :units
      t.integer :cost

      t.timestamps null: false
    end
  end
end
