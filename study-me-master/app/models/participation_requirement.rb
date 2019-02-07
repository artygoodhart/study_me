class ParticipationRequirement < ApplicationRecord
  belongs_to :requirement
  belongs_to :participation
end
