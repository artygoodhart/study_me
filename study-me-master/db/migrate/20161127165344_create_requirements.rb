# Requirements
class CreateRequirements < ActiveRecord::Migration[5.0]
  def change
    create_table :requirements do |t|
      t.string :text, null: false

      t.timestamps
    end
  end
end
