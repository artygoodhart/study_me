class Users::RegistrationsController < Devise::RegistrationsController

  def create
    build_resource(sign_up_params)

    if sign_up_params[:type] == "Researcher"
      @email_domain = sign_up_params[:email].split("@")[1]

      if @university = University.find_by_domain_name(@email_domain)
        resource.university = @university
        ResearcherAttribute.create(researcher: resource)
      else
        flash[:error] = 'Your email address does not match any of our partnered Universities.'
        redirect_to new_user_registration_path
        return
      end
    else
      ParticipantAttribute.create(participant: resource)
    end

    resource.save
    yield resource if block_given?
    if resource.persisted?
      flash[:success] = 'Check your inbox to finish the sign up process!'
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def sign_up_params
    params.require(:user).permit(:email, :type)
  end

  def after_inactive_sign_up_path_for(resource)
    new_user_confirmation_path
  end

  def after_sign_up_path_for(_resource)
    studies_path
  end
end
