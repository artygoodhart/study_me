# Universities controller
class UniversitiesController < PlatformController
  before_action :authenticate_admin

  def index
    @filterrific = initialize_filterrific(
      University,
      params[:filterrific],
      persistencce_id: 'shared_key',
      default_filter_params: {},
      available_filters: [:sorted_by, :search_query]
    ) || return

    @universities = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @new_university = University.new
  end

  def create
    @new_university = University.new(new_university_params)

    if @new_university.save
      redirect_to universities_path
    else
      flash[:error] = @new_university.errors.full_messages.first
      render 'new'
    end
  end

  protected

  def new_university_params
    params.require(:university).permit(
      :name,
      :domain_name,
      :contact_name,
      :contact_email,
      :contact_number,
      :price_per_researcher,
      :billing_date
    )
  end
end
