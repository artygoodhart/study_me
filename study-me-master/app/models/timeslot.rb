class Timeslot < ApplicationRecord
  belongs_to :study

  has_many :participations

  validates :to, :from, presence: true

  filterrific(
  default_filter_params: { sorted_by_from: 'from_asc' },
  available_filters: [
    :sorted_by_from
  ]
  )

  scope :sorted_by_from, lambda { |sort_option|
    direction = sort_option =~ /desc$/ ? 'desc' : 'asc'

    case sort_option.to_s
    when /^from_/
      order("timeslots.from #{direction}")
    else
      raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }

  def is_in_future?
    from.to_date > Date.today
  end
end
