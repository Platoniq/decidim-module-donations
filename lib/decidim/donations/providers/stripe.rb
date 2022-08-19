# frozen_string_literal: true

require "active_merchant"

module Decidim
  module Donations
    module Providers
      class Stripe < AbstractProvider
        class << self
          def form
            Decidim::Donations::CreditCardCheckoutForm
          end
        end

        def initialize(login:, publishable_key:)
          @gateway = ActiveMerchant::Billing::StripePaymentIntentsGateway.new({
                                                                                login: login,
                                                                                publishable_key: publishable_key
                                                                              })
        end

        def purchase(order:, params: {})
          @amount = params[:amount]

          response = gateway.purchase(amount_in_cents, payment_info(order), options(order))
          raise PaymentError, response.message unless response.success?

          @transaction_id = response.params["id"]
          response
        end

        private

        def payment_info(order)
          ActiveMerchant::Billing::CreditCard.new(number: order[:card_number], month: order[:card_exp_month],
                                                  year: order[:card_exp_year], verification_value: order[:card_cvc])
        end

        def options(order)
          @order = {
            currency: order[:currency],
            amount: amount_in_cents,
            description: order[:title],
            payment_method_data: { billing_details: { email: order[:email] } },
            payment_method_types: ["card"],
            metadata: { ip: order[:ip], email: order[:email], description: order[:description] }
          }
        end
      end
    end
  end
end
