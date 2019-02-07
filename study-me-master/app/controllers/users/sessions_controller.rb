module Users
  # Controller for signing in and out
  class SessionsController < Devise::SessionsController
    def after_sign_in_path_for(_resource)
      studies_path
    end
  end
end
