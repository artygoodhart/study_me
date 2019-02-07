class Users::ConfirmationsController < Devise::ConfirmationsController

  def show
    self.resource = resource_class.find_by_confirmation_token(params[:confirmation_token]) if params[:confirmation_token].present?
    super if resource.nil? or resource.confirmed?
  end

  def update
    self.resource = resource_class.find_by_confirmation_token(params[resource_name][:confirmation_token]) if params[resource_name][:confirmation_token].present?
    if params[resource_name][:password] == params[resource_name][:password_confirmation]
      if resource.update_attributes(confirmation_params.except(:confirmation_token))
        self.resource = resource_class.confirm_by_token(params[resource_name][:confirmation_token])
        set_flash_message :notice, :confirmed
        sign_in(User, resource)
        redirect_to after_confirmation_path_for(resource_name, resource)
      else
        render action: "show"
      end
    else
      render action: "show"
    end
  end

  protected

  def after_confirmation_path_for(resource_name, resource)
    if signed_in?(resource_name)
      studies_path
    else
      new_user_session_path
    end
  end

  def confirmation_params
    params.require(resource_name).permit(:confirmation_token, :password, :password_confirmation)
  end

end
