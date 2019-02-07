# Researcher Attributes migration
class CreateResearcherAttributes < ActiveRecord::Migration[5.0]
  def change
    create_table :researcher_attributes do |t|
      t.integer :wallet_total, null: false, default: 0
      t.string :department

      t.belongs_to :researcher, index: true

      t.timestamps
    end
  end
end
