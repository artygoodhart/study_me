class Requirement < ApplicationRecord
  has_many :requirements_studies
  has_many :participation_requirements

  validates :text, presence: true
end
