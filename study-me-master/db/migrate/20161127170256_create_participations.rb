class CreateParticipations < ActiveRecord::Migration[5.0]
  def change
    create_table :participations do |t|
      t.belongs_to  :participant, index: true
      t.belongs_to  :study, index: true
      t.belongs_to  :timeslot, index: true

      t.boolean     :accepted
      t.boolean     :paid, null: false, default: false
      t.boolean     :notify_published_study

      t.timestamps
    end
  end
end
