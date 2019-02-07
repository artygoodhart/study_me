class Researcher < User
  belongs_to :university
  has_many :studies
  has_one :researcher_attribute

  accepts_nested_attributes_for :researcher_attribute

  def self.referrer_options
    super
  end

  def rating
    ratings = Rating.where(user_being_rated_id: id)

    ratings.any? ? ratings.average(:rating).floor : 0
  end

  def current_studies
    studies.select { |study|
      study.timeslots.order(to: :desc).first.to >= DateTime.now unless (study.timeslots_finalised || !study.paid)
    }
  end

  def completed_studies
    studies.select { |study|
      study.timeslots.order(to: :desc).first.to < DateTime.now unless (study.timeslots_finalised || !study.paid)
    }
  end
end
