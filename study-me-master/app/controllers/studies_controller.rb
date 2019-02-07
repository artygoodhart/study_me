# Studies Controller
class StudiesController < PlatformController
  require 'will_paginate/array'

  before_action :authenticate_researcher, only: [:new, :create]
  before_action :authenticate_admin, only: [:feature]

  def index
    @section = params[:section]
    @section ||= 'featured_studies'
    @section_title = page_titles[@section]

    @page = params[:page]
    @page ||= 1

    if @section == 'featured_studies'
      @studies = Study.where(timeslots_finalised: true, paid: true)
                      .order(featured: :desc)
                      .paginate(page: @page, per_page: Study.per_page)
    elsif @section == 'tags' && params[:tag]
      @studies = Study.where('? = ANY (tags)', params[:tag])
                      .paginate(page: @page, per_page: Study.per_page)
    elsif @section == 'all_studies'
      @studies = Study.where(timeslots_finalised: true, paid: true)
                      .sort_by { |study| current_user.eligible?(study) ? 0 : 1 }
                      .paginate(page: @page, per_page: Study.per_page)
    end

    if @studies
      @final_page = @studies.total_pages == @page
    end

    @categories = Study.tags

    return if Study.section_is_valid? @section
    head(404)
  end

  def new
    @new_study = Study.new
  end

  def create
    @new_study = Study.new(new_study_attributes)
    @new_study.researcher = current_user
    @new_study.reward_per_participant = params[:study][:reward_per_participant]

    if @new_study.reward_per_participant == 0
      @new_study.paid = true
    end

    if @new_study.save
      @new_study.add_requirements(params[:study][:requirements_studies])
      redirect_to @new_study
    else
      # flash[:error] = @new_study.errors.first
      render :new
    end
  end

  def update
    @study = current_user.studies.find(params[:id])

    if @study.update(edit_study_params)
      flash[:success] = 'Your PDF or link has been uploaded'
      redirect_to study_path(params[:id])
    else
      flash[:error] = 'Please try uploading your PDF again'
      redirect_to study_path(params[:id])
    end

  end

  def show
    @study = Study.find(params[:id])
    @new_participation = Participation.new
    @current_user = current_user
    @new_rating = Rating.new

    if @study.researcher == current_user && !@study.timeslots_finalised
      return redirect_to new_study_timeslot_path(@study)
    end

    if @study.researcher == current_user
      @new_non_user_participant = NonUserParticipant.new

      @filterrific_participants = initialize_filterrific(
        @study.participations,
        params[:filterrific],
        persistencce_id: 'shared_key',
        default_filter_params: {},
        available_filters: [:sorted_by, :search_query]
      ) || return

      @participants_to_accept = @filterrific_participants.find.page(params[:page])

      # @filterrific_timeslots = initialize_filterrific(
      #   @study.timeslots,
      #   params[:filterrific],
      #   persistencce_id: 'shared_key',
      #   default_filter_params: {},
      #   available_filters: [:sorted_by_from]
      # ) || return
      #
      # @timeslots_view = @filterrific_timeslots.find.page(params[:page])
      
      respond_to do |format|
        format.html
        format.js
      end
    end

    return unless current_user.is_a? Participant

    @participation = @study.participations.find_by_participant_id(current_user.id)

    if @participation && !@participation.timeslot && @participation.accepted.nil?
      redirect_to edit_participation_path(@participation)
    end

    prefilled_requirements = []
    @study.requirements_studies.each do |requirement_study|
      current_user.participations.each do |participation|
        participation.participation_requirements.map { |pr|
          if pr.requirement == requirement_study.requirement
            prefilled_requirements << pr
          end
        }
      end
    end

    @reqs = {}

    Requirement.all.each do |requirement|
      r = prefilled_requirements.select { |pr| pr.requirement == requirement }
      req = r.sort_by(&:created_at).last

      @reqs[req.requirement_id] = req if req
    end
  end

  def search
    @filterrific = initialize_filterrific(
      Study,
      params[:filterrific],
      persistence_id: 'shared_key',
      available_filters: [:search_query]
    ) || return

    @studies_search_results = @filterrific.find.page(params[:page])
    @query = params[:filterrific][:search_query]

    respond_to do |format|
      format.js
      format.html
    end
  end

  def stats
    @study = Study.find_by(id: params[:id])
    return unless (current_user.is_a?(Researcher))
    return if current_user.studies.where(id: params[:id]).empty?
    @study = current_user.studies.find(params[:id])

    respond_to do |format|
      format.json { render json: @study.stats.to_json }
    end
  end

  def feature
    @study = Study.find(params[:id])
    @study.update(featured: params[:featured])
    redirect_to @study
  end

  protected

  def new_study_attributes
    params.require(:study).permit(:title, :background_photo, :aim,
                                  :number_of_participants, :location, :duration,
                                  :min_age, :max_age, gender: [], tags: [])
  end

  def edit_study_params
    params.require(:study).permit(:pdf_attachment, :study_web_link)
  end

  def page_titles
    {
      'featured_studies' => 'Featured Studies',
      'all_studies' => 'All Studies',
      'tags' => 'Categories'
    }
  end
end
