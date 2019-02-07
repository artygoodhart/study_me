class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :user_being_rated, class_name: 'User'
  belongs_to :study

  validates :user, :user_being_rated, :rating, :study, presence: true

  after_create :pay_participant_if_applicable

  def self.default_rating
    0
  end

  protected

  def pay_participant_if_applicable
    return unless user_being_rated.is_a? Participant
    return unless rating > 2

    @participation = study.participations
                          .find_by_participant_id(user_being_rated_id)
    @participation.pay_in_full
  end
end
