class StudiesParticipationsController < PlatformController
  before_action :authenticate_researcher

  def index
    @study = current_user.studies.find(params[:study_id])
    @participations = @study.participations.includes(:participant)
    @new_rating = Rating.new

    render 'studies/participations/index'
  end

  def update
    @participation = Participation.find(params[:id])
    p @participation
    if @participation.accepted == nil
      @participation.update(accepted: params[:participation][:accepted])
      @participation.update(timeslot: nil) unless @participation.accepted
      @participation.send_email_to_say_accepted(params[:study_id])
    else
      p @participation.accepted
    end

    redirect_to @participation.study
  end
end
