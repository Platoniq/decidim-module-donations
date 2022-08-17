# frozen_string_literal: true

require "active_merchant"

module Decidim
  module Donations
    module Providers
      class StripeExpress < AbstractProvider
        def initialize(options = {})
          @gateway = ActiveMerchant::Billing::StripePaymentIntentsGateway.new({
                                                                                login: options[:login],
                                                                                publishable_key: options[:publishable_key]
                                                                              })
        end

        # if multistep, requires a second action from the application to confirm the purchase
        def multistep?
          true
        end

        # depending on the provider the setup_purchase might have different parameters
        # only called on multistep providers
        def setup_purchase(order:, params: {})
          @amount = params[:amount]
          gateway.setup_purchase(amount_in_cents, {
                                   payment_method_types: ["card"]
                                 })
        end

        def purchase(order:, params: {})
          @amount = payment.details["OrderTotal"].to_f
          response = gateway.purchase(amount_in_cents, @order)
          raise PaymentError, response.message unless response.success?

          @transaction_id = response.params["transaction_id"]
          response
        end
      end
    end
  end
end
