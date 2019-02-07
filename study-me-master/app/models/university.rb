# University model
class University < ApplicationRecord
  include PgSearch

  has_many :researchers

  validates :domain_name, :name, :contact_name, :contact_email, :contact_number,
            :price_per_researcher, :billing_date, presence: true

  validates :billing_date, numericality: { greater_than: 0, less_than: 29 }

  validates :domain_name, format: { with: %r{[a-z0-9\-]+\.[a-z0-9\-\/\.]+},
                                    message: 'must be a valid domain name' }

  # Initialize money column properly
  monetize :price_per_researcher_pennies, with_currency: :gbp

  # Default number of universities to display per page in tables
  self.per_page = 10

  pg_search_scope :search_universities, against: [:name, :contact_name],
                                        using: { tsearch: { prefix: true } }

  # Filterrific config
  filterrific(
    default_filter_params: { sorted_by: 'name_asc' },
    available_filters: [
      :sorted_by,
      :search_query
    ]
  )

  scope :sorted_by, lambda { |sort_option|
    direction = sort_option =~ /desc$/ ? 'desc' : 'asc'

    case sort_option.to_s
    when /^name_/
      order("LOWER(universities.name) #{direction}")
    when /^added_to_study_me_/
      order("universities.created_at #{direction}")
    when /^price_per_researcher_/
      order("universities.price_per_researcher #{direction}")
    else
      raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }

  scope :search_query, lambda { |query|
    search_universities(query)
  }

  def next_billing_date
    date = Date.today

    date += 1.month if Date.today.day > billing_date

    date.change(day: billing_date)
  end

  def invoice_total
    price_per_researcher * researchers.count
  end
end
