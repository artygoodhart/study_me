# Rating migration
class CreateRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :ratings do |t|
      t.integer :rating, null: false

      t.belongs_to :user, index: true
      t.belongs_to :user_being_rated, index: true
      t.belongs_to :study, index: true

      t.timestamps
    end
  end
end
