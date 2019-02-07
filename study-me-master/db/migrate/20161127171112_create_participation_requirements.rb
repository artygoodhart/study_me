# For many to many relationship Users and Requirements
class CreateParticipationRequirements < ActiveRecord::Migration[5.0]
  def change
    create_table :participation_requirements do |t|
      t.belongs_to :requirement
      t.belongs_to :participation

      t.boolean :checked, null: false, default: false

      t.timestamps
    end
  end
end
