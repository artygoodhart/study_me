class CreateUniversities < ActiveRecord::Migration[5.0]
  def change
    create_table :universities do |t|

      t.string    :domain_name, null: false
      t.string    :name, null: false
      t.string    :contact_name, null: false
      t.string    :contact_email, null: false
      t.string    :contact_number, null: false
      t.monetize  :price_per_researcher, null: false
      t.integer   :billing_date

      t.timestamps
    end
  end
end
