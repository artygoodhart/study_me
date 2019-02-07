class NonUserParticipantsController < ApplicationController
  def create
    flash[:error] = nil
    @study = current_user.studies.find(params[:study_id])

    @new_non_user_participant = NonUserParticipant.new(
      new_non_user_participant_params
    )

    @new_non_user_participant.study = @study

    if !@new_non_user_participant.save
      flash[:error] = @new_non_user_participant.errors.full_messages.first
    end

    respond_to do |format|
      format.js
    end
  end

  protected

  def new_non_user_participant_params
    params.require(:non_user_participant).permit(
      :gender,
      :date_of_birth,
      :recruitment_method,
      :recruitment_date
    )
  end
end
