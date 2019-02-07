class ParticipationsController < PlatformController
  before_action :authenticate_participant
  before_action :check_managed_account, only: [:edit]

  def create
    @study = Study.find(params[:participation][:study_id])

    if @study.full?
      flash[:error] = 'Sorry, this study has reached its maximum number of '\
                      'participants'

      return redirect_to @study
    elsif !@study.timeslots_finalised
      flash[:error] = 'Sorry, this study is not yet open to participants'

      return redirect_to @study
    elsif !@study.joineable?
      flash[:error] = 'Sorry, you cannot currently join this study'

      return redirect_to @study
    end

    @participation = Participation.create(
      participant: current_user,
      study: @study
    )

    params[:participation][:participation_requirements].each do |_key, value|
      requirement = Requirement.find(value[:requirement_id])
      ParticipationRequirement.create(
        requirement: requirement,
        participation: @participation,
        checked: value[:checked]
      )
    end

    redirect_to edit_participation_path(@participation)
  end

  def edit
    @participation = current_user.participations.find(params[:id])
    @study = @participation.study

    return redirect_to study_path(@study) if @participation.timeslot

    if params[:page]
      # Use the provided date_from and then add 8 days to get the date to (an
      # extra day to account for this being a DateTime, so we want to get all
      # timeslots on the last day, up to 23:59)
      from = DateTime.parse(params[:page][:date_from])
      to = from + 7.days
      from = [from, DateTime.now.change({hour: 0, minute: 0, second: 0})].max
      @timeslots = @study.timeslots
                         .where('timeslots.from >= ? AND timeslots.from < ?',
                                from, to)
                         .select { |timeslot| !timeslot.participations.any? }
    end

    respond_to do |format|
      format.html
      format.json { render json: @timeslots.to_json }
    end
  end

  def update
    @participation = current_user.participations.find(params[:id])
    @timeslot = @participation.study.timeslots.find(params[:participation][:timeslot_id])

    if @timeslot.participations.any?
      flash[:error] = 'Sorry, this timeslot is taken'
      redirect_to edit_participation_path(@participation)
    else
      @participation.timeslot = @timeslot
      @participation.save
      redirect_to study_path(@participation.study)
    end
  end

  protected

  def check_managed_account
    @participation = current_user.participations.find(params[:id])
    @study = @participation.study
    return if @study.reward_per_participant_pennies == 0

    unless current_user.participant_attribute.managed_account_id
      flash[:error] = 'You need to add your bank details before you can join a paid study, so you can receive your reward!'
      return redirect_to payments_path(return_to: @study.id)
    end
  end
end
