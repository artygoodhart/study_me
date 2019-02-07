# Helpers for use throughout the application
module ApplicationHelper
  def format_error(error)
    "#{error.first.to_s.humanize} #{error.last}"
  end

  def human_date(date)
    if date.today?
      'Today'
    elsif date.year == Date.today.year
      date.strftime('%B %e')
    else
      date.strftime('%B %e %Y')
    end
  end

  def human_datetime(datetime)
    date = human_date(datetime.to_date)

    time = datetime.strftime('%l:%M %p')

    "#{date}, #{time}"
  end

  def active_class?(current_path)
    return 'active' if request.path == current_path
  end

  def search_path?
    request.path != search_studies_path
  end

  def length_of_text(text, max_length)
    new_text = text.slice(0, max_length)
    new_text << '...' if text.length > max_length
    new_text
  end

  def highlight_query(string, query)
    # Return the unmodified string if there are no occurrances of query
    return string unless (index = string =~ /#{query}/i)

    # Get the portion of the string after the first occurance of the query
    substring = string.slice(index + query.length, string.length)

    # Call this function again without the first occurrance
    substring = highlight_query(substring, query)

    # Insert bold tags around the first occurrance of the query
    string = string.slice(0, index + query.length)
                   .insert(index + query.length, '</b>')
                   .insert(index, '<b>')

    # Return the string concatinated with substring
    string + substring
  end
end
