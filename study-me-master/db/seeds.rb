# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rails db:seed command (or created
# alongside the database with db:setup).
#
# Examples:
#
#  movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#  Character.create(name: 'Luke', movie: movies.first)

require 'ffaker'

amount_of_users = 10
number_of_universities = 15
number_of_studies = 25

# Create all admins for herokuapp live site
Admin.create(
  name: 'Archie',
  email: 'archie@taylorkennedydyson.com',
  password: 'password',
  confirmed_at: DateTime.now
)
p 'Admin Archie Created'

Admin.create(
  name: 'Barnaby',
  email: 'barnaby@taylorkennedydyson.com',
  password: 'password',
  confirmed_at: DateTime.now
)
p 'Admin Barnaby Created'

Admin.create(
  name: 'Jess',
  email: 'jess@study-me.com',
  password: 'password',
  confirmed_at: DateTime.now
)
p 'Admin Jess Created'

# Create n universities
number_of_universities.times do |count|
  name = FFaker::Name.name
  domain_name = FFaker::Internet.domain_name

  University.create(
    name: FFaker::Education.school,
    domain_name: domain_name,
    contact_name: name,
    contact_email: "#{name.split(' ').join('.').downcase}@#{domain_name}",
    contact_number: FFaker::PhoneNumber.phone_number.to_s,
    price_per_researcher: 10,
    billing_date: rand(28) + 1
  )
  p "University #{count} created"
end

# Create University of Nottingham
nottingham_contact_name = FFaker::Name.name

University.create(
  name: 'University of Nottingham',
  domain_name: 'nottingham.ac.uk',
  contact_name: nottingham_contact_name,
  contact_email: "#{nottingham_contact_name.split(' ').join('.').downcase}@nottingham.ac.uk",
  contact_number: FFaker::PhoneNumber.phone_number.to_s,
  price_per_researcher: 10,
  billing_date: 28
)
p "University nottingham created"

# Create all users
amount_of_users.times do |count|
  year = "19#{rand(43).to_s.rjust(2, '0')}".to_i + 57
  date_of_birth = Date.new(year, rand(12) + 1, rand(28) + 1)

  participant = Participant.create(
    name: FFaker::Name.name,
    email: FFaker::Internet.email,
    date_of_birth: date_of_birth,
    gender: FFaker::Gender.random,
    password: 'password',
    confirmed_at: DateTime.now
  )
  p "Participant #{count} created"

  ParticipantAttribute.create(
    occupation: FFaker::Job.title,
    country_of_residence: FFaker::AddressUK.country,
    participant: participant
  )
  p "Participant Attribute #{count} created"
end

amount_of_users.times do |count|
  university = University.all.sample

  researcher = Researcher.create(
    name: FFaker::Name.name,
    email: "#{FFaker::Internet.user_name}@#{university.domain_name}",
    password: 'password',
    confirmed_at: DateTime.now,
    university: university
  )
  p "Researcher #{count} created"

  ResearcherAttribute.create(
    department: FFaker::Education.major,
    researcher: researcher
  )
  p "Researcher Attribute #{count} created"
end

# Create requirement
req1 = Requirement.create(
  text: 'Are you in favour of Trump?'
)
p "Requirement created"

req2 = Requirement.create(
  text: 'Do you earn more than £100,000?'
)
p "Requirement created"

req3 = Requirement.create(
  text: 'Do you have more than 5 friends?'
)
p "Requirement created"

requirements = [req1, req2, req3]

participants = Participant.all
researchers = Researcher.all

# Create studies
number_of_studies.times do |count|
  para = FFaker::Book.description
  min_age = rand(43) + 17
  # para = para[0, 199] if para.length > 200
  study = Study.create(
    background_photo:
      File.new("#{Rails.root}/app/assets/images/#{%w(brain-photo-studies art-tag-image business-tag-image sea-photo-studies earth-photo snow-photo study-photo).sample}.png"),
    title: FFaker::HipsterIpsum.sentence,
    aim: para,
    reward_per_participant_pennies: rand(100) * 100,
    number_of_participants: rand(10) + 2,
    location: %w(Physical Virtual).sample,
    duration: rand(100),
    tags: Study.tags.sample(rand(3) + 1),
    timeslots_finalised: false,
    building_name: FFaker::Product.brand,
    building_number: FFaker::AddressUK.building_number,
    street_name: FFaker::AddressUK.street_name,
    town: FFaker::AddressUK.city,
    postcode: FFaker::AddressUK.postcode,
    researcher: researchers[rand(researchers.length)],
    min_age: min_age,
    max_age: rand(60) + min_age,
    gender: %w(male female).sample(rand(2) + 1),
    paid: [true, false].sample,
    featured: (rand(4) == 0)
  )
  p "Study #{count} created"

  requirements.sample(rand(3) + 1).each do |requirement|
    study.requirements_studies << RequirementsStudy.create(
      requirement: requirement,
      checked: [true, false].sample
    )
  end
  p "Study #{count} requirements created"

  loop do |timeslot_count|
    start = DateTime.now.change(
      hour: 9 + rand(9),
      min: [0, 15, 30, 45].sample
    ) + (5 + rand(20)).days

    end_time = start + rand(2).hours + [0, 15, 30, 45].sample.minutes

    end_time += 30.minutes if start == end_time

    timeslot = Timeslot.create(
      from: start,
      to: end_time,
      study: study
    )
    p "Timeslot for study #{count}"
    p timeslot

    loop do |participation_count|
      participant_for_participation = participants[rand(participants.length)]
      if participant_for_participation.eligible?(study)
        accepted = [true, false].sample

        participation = Participation.create(
          participant: participant_for_participation,
          study: study,
          timeslot: timeslot,
          accepted: accepted,
          paid: [accepted, false].sample,
          notify_published_study: [accepted, false].sample
        )
        p "Participation #{participation_count} created"

        study.requirements_studies.each do |requirement_study|
          ParticipationRequirement.create(
            participation: participation,
            requirement: requirement_study.requirement,
            checked: requirement_study.checked
          )
        end
      end
      break if [0, 1].sample.zero? || study.full?
    end

    break if study.timeslots.count == study.number_of_participants
  end

  if study.timeslots.count >= study.number_of_participants
    study.timeslots_finalised = true
    study.paid = [true, false].sample
    study.save
    p "Study #{count} timeslots_finalised"
  end

  # Create ratings
  10.times do
    researcher = researchers.select { |researcher| researcher.studies.any? }.sample

    Rating.create(
      rating: rand(5),
      user: participants.sample,
      user_being_rated: researcher,
      study: researcher.studies.sample
    )
  end

  10.times do
    participant = participants.select { |participant| participant.studies.any? }.sample

    Rating.create(
      rating: rand(5),
      user: researchers.sample,
      user_being_rated: participant,
      study: participant.studies.sample
    )
  end
end
