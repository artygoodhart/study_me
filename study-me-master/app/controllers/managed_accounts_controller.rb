# Controller to create the new managed accounts
class ManagedAccountsController < PlatformController
  require 'stripe'

  def new
    return redirect_to studies_path unless current_user.is_a? Participant

    managed_account_id = current_user.participant_attribute.managed_account_id

    if managed_account_id
      managed_account = Stripe::Account.retrieve(managed_account_id)
      external_account_id = managed_account[:external_accounts][:data].first[:id]
      @balance = Stripe::Balance.retrieve(stripe_account: managed_account_id)[:available].first[:amount]
      @transactions = Stripe::Transfer.list(destination: managed_account_id)[:data]
      # @transactions << Stripe::Payout.list(destination: external_account_id)[:data]
    end
  end

  def create
    return redirect_to studies_path unless current_user.is_a? Participant
    return redirect_to studies_path if current_user.participant_attribute.managed_account_id

    begin
      account = Stripe::Account.create(
        managed: 'true',
        country: params[:managed_account][:country],
        email: current_user.email,
        legal_entity: {
          dob: {
            day: current_user.date_of_birth.day,
            month: current_user.date_of_birth.month,
            year: current_user.date_of_birth.year
          },
          first_name: current_user.name.split(' ').first,
          last_name: current_user.name.split(' ').last,
          type: 'individual',
          address: {
            line1: params[:managed_account][:address_line1],
            city: params[:managed_account][:city],
            postal_code: params[:managed_account][:postcode]
          }
        },
        payout_schedule: {
          delay_days: 7,
          interval: 'monthly',
          monthly_anchor: 1
        },
        tos_acceptance: {
          date: Date.today.to_time.to_i,
          ip: request.remote_ip
        }
      )

      account.external_accounts.create(
        external_account: {
          object: 'bank_account',
          country: 'GB',
          currency: 'gbp',
          account_holder_name: params[:managed_account][:account_holder_name],
          account_holder_type: 'individual',
          routing_number: params[:managed_account][:sort_code].split('-').join(''),
          account_number: params[:managed_account][:account_number],
        }
      )

      current_user.participant_attribute.managed_account_id = account.id
      current_user.save

      flash[:success] = 'Your account details have been saved securely'

      if params[:return_to]
        return redirect_to study_path(params[:return_to])
      else
        return redirect_to profile_path
      end
    rescue Stripe::RateLimitError => e
      # Too many requests made to the API too quickly
      p e
      flash[:error] = 'Sorry, an error occurred'
      render :new
    rescue Stripe::InvalidRequestError => e
      # Invalid parameters were supplied to Stripe's API
      p e
      flash[:error] = e.message
      render :new
    rescue Stripe::AuthenticationError => e
      # Authentication with Stripe's API failed
      # (maybe you changed API keys recently)
      p e
      flash[:error] = 'Sorry, an error occurred'
      render :new
    rescue Stripe::APIConnectionError => e
      # Network communication with Stripe failed
      p e
      flash[:error] = 'Sorry, an error occurred'
      render :new
    rescue Stripe::StripeError => e
      # Display a very generic error to the user, and maybe send
      # yourself an email
      p e
      flash[:error] = 'Sorry, an error occurred'
      render :new
    rescue => e
      # Something else happened, completely unrelated to Stripe
      p e
      flash[:error] = 'Sorry, an error occurred'
      render :new
    end
  end
end
