class CreateRequirementsStudies < ActiveRecord::Migration[5.0]
  def change
    create_table :requirements_studies do |t|
      t.belongs_to  :requirement, index: true
      t.belongs_to  :study, index: true

      t.boolean     :checked, null: false, default: true
    end
  end
end
