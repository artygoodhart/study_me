class Participant < User
  has_one :participant_attribute
  has_many :participations
  has_many :studies, through: :participations

  accepts_nested_attributes_for :participant_attribute

  def self.referrer_options
    super
  end

  def eligible?(study)
    gender_eligible = study.gender.include?(gender.downcase)
    age_eligible = age >= study.min_age && age <= study.max_age
    gender_eligible && age_eligible
  end

  def age
    age = (Date.today.year - date_of_birth.year)

    (Date.today.month < date_of_birth.month) || ((Date.today.month == date_of_birth.month) && (Date.today.day < date_of_birth.day)) ? age - 1 : age
  end

  def current_studies
    participations.select { |participation|
      participation.timeslot && participation.timeslot.to > DateTime.now
    }.map { |participation| participation.study }
  end

  def completed_studies
    participations.select { |participation|
      participation.timeslot && participation.timeslot.to <= DateTime.now
    }.map { |participation| participation.study }
  end

  def studies_to_rate
    participations.select { |participation|
      participation.timeslot && participation.timeslot.to <= DateTime.now &&
      !participation.study.ratings.where(user: self).any?
    }.map { |participation| participation.study }
  end

  def rating
    ratings = Rating.where(user_being_rated_id: id)

    ratings.any? ? ratings.average(:rating).floor : 0
  end

  def show_rating
    ratings = Rating.where(user_being_rated_id: id)

    ratings.any? ? ratings.average(:rating).floor : "This participant has not yet been rated"
  end
end
