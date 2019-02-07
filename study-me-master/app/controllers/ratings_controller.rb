# Ratings Controller
class RatingsController < ActionController::Base
  before_action :check_user_being_rated, only: [:create]

  def create
    @new_rating = Rating.new(new_ratings_params)
    @new_rating.user = current_user

    unless @new_rating.save
      flash[:error] = @new_rating.errors.full_messages.first
    end

    respond_to do |format|
      format.html { redirect_to @new_rating.study }
      format.json { render json: @new_rating.to_json }
    end
  end

  protected

  def new_ratings_params
    params.require(:rating).permit(:rating, :study_id, :user_being_rated_id)
  end

  def check_user_being_rated
    if current_user.is_a? Researcher
      @study = current_user.studies.find(params[:rating][:study_id])
      @participation = @study.participations
                             .find_by_participant_id(
                               params[:rating][:user_being_rated_id]
                             )
      @user_being_rated = @participation.participant

      return false if Rating.where(study: @study,
                                   user_being_rated: @user_being_rated).any?

      true
    elsif current_user.is_a? Participant
      @study = Study.find(new_ratings_params[:study_id])

      unless @study.user_can_rate_researcher?(current_user)
        return false
      end

      @researcher = @study.researcher

      @participation = @study.participations.find_by_participant_id(current_user.id)
      if params[:notify_published_study]
        @participation.notify_published_study = true
      else
        @participation.notify_published_study = false
      end
      
      @participation.save

      return false if Rating.where(study: @study,
                                   user_being_rated: @researcher).any?

      true
    else
      false
    end
  end
end
