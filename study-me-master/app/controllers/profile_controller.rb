# Profile controller
class ProfileController < PlatformController
  def index
    @section = params[:section]

    if current_user.is_a? Admin
      return redirect_to root_path
    elsif current_user.is_a? Researcher
      @section ||= 'my_studies'
    elsif current_user.is_a? Participant
      @section ||= 'current_studies'
      @studies_to_rate = current_user.studies_to_rate
    end

    @section_title = page_titles[@section]

    @my_studies = current_user.studies
    @current_studies = current_user.current_studies
    @completed_studies = current_user.completed_studies

    @studies = studies_to_be_included(@section)

    return if section_is_valid? @section

    head(404)
  end

  protected

  def page_titles
    {
      'current_studies' => 'Current Studies',
      'favourite_studies' => 'Favourite Studies',
      'completed_studies' => 'Completed Studies'
    }
  end

  def valid_sections
    %w(current_studies my_studies studies_to_rate completed_studies)
  end

  def section_is_valid?(section)
    valid_sections.include? section
  end

  def studies_to_be_included(section)
    case section
    when 'my_studies'
      @my_studies
    when 'studies_to_rate'
      @studies_to_rate
    when 'current_studies'
      @current_studies
    when 'completed_studies'
      @completed_studies
    end
  end
end
