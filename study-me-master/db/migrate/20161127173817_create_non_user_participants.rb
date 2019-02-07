class CreateNonUserParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :non_user_participants do |t|
      t.date :date_of_birth
      t.string :gender
      t.string :recruitment_method
      t.date :recruitment_date, null: false

      t.belongs_to :study, index: true

      t.timestamps
    end
  end
end
