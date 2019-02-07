class Participation < ApplicationRecord
  require 'stripe'

  belongs_to :participant
  belongs_to :study
  belongs_to :timeslot
  has_many :participation_requirements

  before_create :ensure_unique

  # Filterrific config
  filterrific(
    default_filter_params: { sorted_by: 'created_at_asc' },
    available_filters: [
      :sorted_by
    ]
  )

  scope :sorted_by, lambda { |sort_option|
    direction = sort_option =~ /desc$/ ? 'desc' : 'asc'

    case sort_option.to_s
    when /^created_at_/
      order("participations.created_at #{direction}")
    else
      raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }

  def send_email_to_say_accepted(study_id)
    p "Accepted: #{accepted}"
    p "participation_id = #{id}"
    NotificationMailer.send_accepted_email(id, study_id).deliver_now
  end

  def pay_in_full
    return unless participant.participant_attribute.managed_account_id

    begin
      Stripe::Transfer.create({
        amount: study.reward_per_participant_pennies,
        currency: 'gbp',
        destination: participant.participant_attribute.managed_account_id,
        metadata: { participation_id: id }
      })

      self.paid = true
      save
    rescue Stripe::RateLimitError => e
      # Too many requests made to the API too quickly
      p e
    rescue Stripe::InvalidRequestError => e
      # Invalid parameters were supplied to Stripe's API
      p e
    rescue Stripe::AuthenticationError => e
      # Authentication with Stripe's API failed
      # (maybe you changed API keys recently)
      p e
    rescue Stripe::APIConnectionError => e
      # Network communication with Stripe failed
      p e
    rescue Stripe::StripeError => e
      # Display a very generic error to the user, and maybe send
      # yourself an email
      p e
    rescue => e
      # Something else happened, completely unrelated to Stripe
      p e
    end
  end

  def rated
    Ratings.where(study_id: study_id, user_being_rated_id: participant_id).any?
  end

  protected

  def ensure_unique
    # Return true if there are no other participations with both the same study
    # and the same participant
    !Participation.where(participant: self.participant, study: self.study).any?
  end
end
