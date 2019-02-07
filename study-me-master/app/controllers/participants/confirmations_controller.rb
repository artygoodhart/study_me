class Participants::ConfirmationsController < Users::ConfirmationsController

  def show
    super

    @referrer_options = Participant.referrer_options
  end

  def update
    @participant = User.find_by_confirmation_token! params[:participant][:confirmation_token]
    @participant.update(confirmation_params)

    if @participant.valid?
      @participant.confirm
      @participant.update(confirmation_token: nil)
      set_flash_message :notice, :confirmed
      sign_in(User, @participant)
      redirect_to after_confirmation_path_for(resource_name, resource)
    else
      render :action => 'show'
    end
  end

  protected

  def confirmation_params
    params.require(:participant).permit(:name, :gender, :date_of_birth, :password, :referrer, participant_attribute_attributes: [:id, :occupation, :country_of_residence])
  end

end
