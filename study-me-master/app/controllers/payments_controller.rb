class PaymentsController < ApplicationController
  require 'stripe'

  def create
    @study = current_user.studies.find(params[:study_id])

    begin
      Stripe::Charge.create(
        amount: @study.total_amount_pennies,
        currency: "gbp",
        source: params[:stripeToken], # obtained with Stripe.js
        description: "Charge for #{current_user.email}\'s study"
      )
    rescue Stripe::CardError => e
      flash[:error] = e.json_body[:error][:message]
    rescue Stripe::RateLimitError => e
      # Too many requests made to the API too quickly
      p e.json_body[:error][:message]
      flash[:error] = 'Sorry, an error occured. Your card was not charged.'
    rescue Stripe::InvalidRequestError => e
      # Invalid parameters were supplied to Stripe's API
      p e.json_body[:error][:message]
      flash[:error] = 'Sorry, an error occured. Your card was not charged.'
    rescue Stripe::AuthenticationError => e
      # Authentication with Stripe's API failed
      # (maybe you changed API keys recently)
      p e.json_body[:error][:message]
      flash[:error] = 'Sorry, an error occured. Your card was not charged.'
    rescue Stripe::APIConnectionError => e
      # Network communication with Stripe failed
      p e.json_body[:error][:message]
      flash[:error] = 'Sorry, an error occured. Your card was not charged.'
    rescue Stripe::StripeError => e
      # Display a very generic error to the user, and maybe send
      # yourself an email
      p e.json_body[:error][:message]
      flash[:error] = 'Sorry, an error occured. Your card was not charged.'
    end

    unless flash[:error]
      @study.paid = true
      @study.save
      flash[:success] = 'Thank you for your payment.'
    end

    redirect_to @study
  end
end
