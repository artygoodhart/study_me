class NotificationMailer < ApplicationMailer
  def send_accepted_email(particpation_id, study_id)
    @participation = Participation.find_by(id: particpation_id)
    @participant = Participant.find_by(id: @participation.participant_id)
    @study = Study.find_by(id: study_id)

    mail(
      to: @participant.email,
      subject: "You have been #{@participation.accepted ? 'accepted' : 'rejected'}"
    )
  end
end
