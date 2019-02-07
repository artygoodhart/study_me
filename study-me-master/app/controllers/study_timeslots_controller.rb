class StudyTimeslotsController < PlatformController
  before_action :authenticate_researcher

  def index
    @study = Study.find_by(id: params[:study_id])

    @filterrific_timeslots = initialize_filterrific(
      @study.timeslots,
      params[:filterrific],
      persistencce_id: 'shared_key',
      default_filter_params: {},
      available_filters: [:sorted_by_from]
    ) || return

    @timeslots_view = @filterrific_timeslots.find.page(params[:page])

    respond_to do |format|
      format.html
      format.js
    end
  end
end
