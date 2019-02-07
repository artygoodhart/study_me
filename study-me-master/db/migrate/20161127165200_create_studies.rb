# Studies migration
class CreateStudies < ActiveRecord::Migration[5.0]
  def change
    create_table :studies do |t|
      t.attachment  :background_photo
      t.attachment  :pdf_attachment
      t.string      :study_web_link
      t.string      :title, null: false
      t.string      :aim, null: false
      t.monetize    :reward_per_participant, null: false
      t.integer     :number_of_participants, null: false
      t.string      :location, null: false
      t.integer     :duration, null: false
      t.text        :tags, array: true, default: []
      t.boolean     :timeslots_finalised
      t.boolean     :paid, null: false, default: false
      t.boolean     :featured, null: false, default: false

      t.integer     :min_age
      t.integer     :max_age
      t.text        :gender, array: true, default: %w(male female)

      # Address attributes
      t.string      :building_name
      t.string      :building_number
      t.string      :street_name
      t.string      :town
      t.string      :postcode
      t.string      :country, null: false, default: 'UK'

      t.belongs_to  :researcher, index: true

      t.timestamps
    end
  end
end
