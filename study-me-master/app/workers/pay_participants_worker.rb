class PayParticipantsWorker
  include Sidekiq::Worker

  def perform(participation_id)
    participation = Participation.find(participation_id)
    return unless participation.timeslot.to.to_date - 2.weeks >= Date.today
    participation.pay_in_full
  end
end
