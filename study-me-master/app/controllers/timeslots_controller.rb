class TimeslotsController < PlatformController
  def index
    @study = current_user.studies.find(params[:study_id])
    # Use the provided date_from and then add 8 days to get the date to (an
    # extra day to account for this being a DateTime, so we want to get all
    # timeslots on the last day, up to 23:59)
    from = DateTime.parse(params[:page][:date_from])
    to = from + 8.days
    @timeslots = @study.timeslots
                       .where('timeslots.from >= ? AND timeslots.from < ?',
                              from, to)

    respond_to do |format|
      format.json { render json: @timeslots.to_json }
    end
  end

  def new
    @study = current_user.studies.find(params[:study_id])
    return redirect_to @study if @study.timeslots_finalised
    @number = 10
  end

  def create
    @study = current_user.studies.find(params[:study_id])
    @new_timeslot = Timeslot.new

    timeslot = params[:timeslot]
    from = DateTime.parse("#{timeslot[:date]} #{timeslot[:start_time]}")
    to = DateTime.parse("#{timeslot[:date]} #{timeslot[:end_time]}")

    return if from == to

    @new_timeslot.to = to
    @new_timeslot.from = from
    @new_timeslot.study = @study
    @new_timeslot.save

    respond_to do |format|
      format.json { render json: @new_timeslot }
    end
  end

  def destroy
    @timeslot = Timeslot.find(params[:id])

    if @timeslot.study.researcher == current_user
      @timeslot.delete
      response = { status: 204 }
    else
      response = { status: 403, error: "Forbidden" }
    end

    respond_to do |format|
      format.json { render json: response }
    end
  end

  def finalise
    @study = current_user.studies.find(params[:id])

    if @study.timeslots.count >= @study.number_of_participants
      @study.timeslots_finalised = true
      @study.save
    else
      flash[:error] = 'You must have at least as many timeslots as the number '\
                      'of participants that you have set for your study.'
    end

    redirect_to @study
  end
end
