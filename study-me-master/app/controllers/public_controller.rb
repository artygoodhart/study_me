# Controller for public site controllers to inherit
class PublicController < ActionController::Base
  protect_from_forgery with: :exception

  layout 'public'
end
