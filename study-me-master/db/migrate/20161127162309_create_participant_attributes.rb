# Attributest that is required for the participants
class CreateParticipantAttributes < ActiveRecord::Migration[5.0]
  def change
    create_table :participant_attributes do |t|
      t.string :occupation
      t.string :country_of_residence
      t.string :managed_account_id

      t.belongs_to :participant, index: true

      t.timestamps
    end
  end
end
