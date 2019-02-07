# Controller for contact form
class ContactController < PublicController
  def new
    @new_contact = Contact.new
  end

  def create
    @contact = Contact.new(new_contact_params)

    if @contact.valid?
      ContactMailer.send_contact_form(@contact).deliver_now
    else
      @error = 'Cannot send message'
    end

    respond_to do |format|
      format.js
    end
  end

  protected

  def new_contact_params
    params.require(:contact).permit(:name, :email, :message)
  end
end
