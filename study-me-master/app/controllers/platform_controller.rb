# Controller for platform controllers to inherrit
class PlatformController < ApplicationController
  before_action :authenticate_user!

  layout 'platform'

  protected

  def authenticate_admin
    return if current_user.is_a? Admin

    head(403)
  end

  def authenticate_participant
    return if current_user.is_a? Participant

    head(403)
  end

  def authenticate_researcher
    return if current_user.is_a? Researcher

    head(403)
  end
end
