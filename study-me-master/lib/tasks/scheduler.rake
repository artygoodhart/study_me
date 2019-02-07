desc 'This task is called by the Heroku scheduler add-on'

task pay_participants: :environment do |t, args|
  Participation.where(paid: false, accepted: true).each do |participation|
    return if participation.rated
    PayParticipantsWorker.perform_async(participation.id)
  end
end
