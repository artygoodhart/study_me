# Timeslot migration
class CreateTimeslots < ActiveRecord::Migration[5.0]
  def change
    create_table :timeslots do |t|
      t.datetime :from, null: false
      t.datetime :to, null: false

      t.belongs_to :study, index: true

      t.timestamps
    end
  end
end
