class NonUserParticipant < ApplicationRecord
  belongs_to :study

  validates :study_id, :recruitment_date, presence: true
end
