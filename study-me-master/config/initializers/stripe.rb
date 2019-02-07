require 'stripe'

Stripe.api_key = if Rails.env.production?
                   ENV['stripe_live_secret']
                 else
                   ENV['stripe_test_secret']
                 end
