class UserMailer < Devise::Mailer

  default template_path: "users/mailer"

  def confirmation_instructions(record, token, options={})

    if record.type == "Participant"
      options[:template_path] = "participants/mailer"
    elsif record.type == "Researcher"
      options[:template_path] = "researchers/mailer"
    end

    super
  end

end
