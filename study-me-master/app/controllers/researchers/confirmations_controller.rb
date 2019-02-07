class Researchers::ConfirmationsController < Users::ConfirmationsController

  def show
    super

    @referrer_options = Researcher.referrer_options
  end

  def update
    @researcher = User.find_by_confirmation_token! params[:researcher][:confirmation_token]
    @researcher.update(confirmation_params)

    if @researcher.valid?
      @researcher.confirm
      @researcher.update(confirmation_token: nil)
      set_flash_message :notice, :confirmed
      sign_in(User, @researcher)
      redirect_to after_confirmation_path_for(resource_name, resource)
    else
      render :action => 'show'
    end
  end

  protected

  def confirmation_params
    params.require(:researcher).permit(:name, :gender, :date_of_birth, :password, :referrer, researcher_attribute_attributes: [:id, :department])
  end

end
