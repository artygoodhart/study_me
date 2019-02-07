# Study Model
class Study < ApplicationRecord
  include PgSearch

  belongs_to :researcher

  has_many :participations
  has_many :participants, through: :participations
  has_many :requirements_studies
  has_many :non_user_participants
  has_many :timeslots
  has_many :ratings

  validates :title, :aim, :reward_per_participant_pennies, :location, :duration,
            :min_age, :max_age, :gender, :number_of_participants, presence: true
  validates_length_of :aim, maximum: 1000

  # Initialize money column properly
  monetize :reward_per_participant_pennies, with_currency: :gbp

  include BackgroundPhotoAttachment
  include PDFAttachment

  # Default number of universities to display per page in tables
  self.per_page = 10

  pg_search_scope :search_studies, against: [:title],
                                   using: { tsearch: { prefix: true } }

  filterrific(
    available_filters: [
      :sorted_by,
      :search_query,
      :sorted_by_from
    ]
  )

  def self.section_is_valid?(section)
    valid_sections.include? section
  end

  def self.tags
    %w(art biology business computers environment law physics
       pyschology technology)
  end

  def self.valid_sections
    %w(tags all_studies featured_studies)
  end
  # protected_methods :valid_sections

  def add_requirements(requirements)
    requirements.each do |_key, value|
      break if value[:text] == ''

      requirement = Requirement.where('lower(text) = ?', value[:text].downcase)
                               .first

      requirement = Requirement.create(text: value[:text]) if requirement.nil?

      requirements_studies << RequirementsStudy.create(
        requirement: requirement,
        checked: value[:checked]
      )
    end

    save
  end

  def stats
    {
      genders: {
        male: participants.where(gender: 'male').count,
        female: participants.where(gender: 'female').count
      },
      ages: collect_ages,
      participations: collect_participations
    }
  end

  def accepted_participants
    participations.where(accepted: true)
  end

  def first_timeslot_complete
    timeslots.order(:to).first.to.past?
  end

  def full?
    participations.count >= number_of_participants
  end

  def joineable?
    !full? && paid && timeslots_finalised
  end

  scope :search_query, lambda { |query|
    search_studies(query)
  }

  def lowest_age
    if participants.any?
      participants.to_a.sort_by(&:age).first.age
    else
      0
    end
  end

  def highest_age
    if participants.any?
      participants.to_a.sort_by(&:age).last.age
    else
      0
    end
  end

  def mean_age
    if participants.any?
      participants.to_a.collect(&:age).sum / participants.count
    else
      0
    end
  end

  def user_can_rate_researcher?(current_user)
    participation = participations.find_by_participant_id(current_user.id)
    return false unless current_user.is_a?(Participant) && participation
    timeslot = participation.timeslot
    return false unless timeslot
    rating = Rating.where(user_id: current_user.id, study_id: id)
    return false if rating.any?
    participations.pluck(:participant_id).include?(current_user.id) &&
      DateTime.now >= timeslot.to
  end

  def total_amount_pennies
    (reward_per_participant_pennies * number_of_participants * Study.markup).to_i
  end

  def self.markup
    1.15
  end

  protected

  def collect_ages
    study_participants = participants.to_a
    ages = {}

    study_participants.collect(&:age).each do |age|
      ages[age] = study_participants
                  .select { |participant| participant.age == age }.length
    end

    ages
  end

  def collect_participations
    # p '**********************************************'
    # p accepted_participants.count == 0
    # p '**********************************************'
    return response = {} if accepted_participants.count == 0
    ordered_participations = participations.where(accepted: true)
                             .sort_by(&:created_at)

    dates_difference = ordered_participations.last.created_at - created_at

    response = if dates_difference > 1.month
                 {
                   study_me: week_by_week_participations(created_at,
                                               ordered_participations
                                               .last.created_at,
                                               ordered_participations.to_a
                                               .collect(&:created_at)),
                   external: week_by_week_participations(created_at,
                                               ordered_participations
                                               .last.created_at,
                                               non_user_participants.to_a
                                               .collect(&:recruitment_date))
                 }

               else
                 {
                   study_me: day_by_day_participations(created_at,
                                             ordered_participations
                                             .last.created_at,
                                             ordered_participations.to_a
                                             .collect(&:created_at)),
                   external: day_by_day_participations(created_at,
                                             ordered_participations
                                             .last.created_at,
                                             non_user_participants.to_a
                                             .collect(&:recruitment_date))
                 }
               end

    response
  end

  def day_by_day_participations(first_date, last_date, study_participations)
    response = {
      scale: 'day',
      dates: {}
    }

    date = first_date

    while date.to_date <= last_date.to_date
      response[:dates][date.strftime('%Y-%m-%d')] =
        study_participations
        .select { |p| p.to_date <= date }.length

      response[:dates][date.strftime('%Y-%m-%d')] ||=
        response[:dates][date - 1.day]
      date += 1.day
    end

    response
  end

  def week_by_week_participations(first_date, last_date, study_participations)
    response = {
      scale: 'week',
      dates: {}
    }

    date = first_date

    while date.to_date.strftime('%W') <= last_date.to_date.strftime('%W')
      response[:dates][date.strftime('%Y-%W')] =
        study_participations
        .select { |p| p.to_date.strftime('%W') <= date.strftime('%W') }.length

      response[:dates][date.strftime('%Y-%W')] ||=
        response[:dates][date - 1.day]
      date += 1.week
    end

    response
  end
end
