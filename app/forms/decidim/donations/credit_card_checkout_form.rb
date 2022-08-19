# frozen_string_literal: true

module Decidim
  module Donations
    class CreditCardCheckoutForm < CheckoutForm
      attribute :card_number
      attribute :card_expiration
      attribute :card_cvc

      validates :card_number, format: { with: /\A\d{4} \d{4} \d{4} \d{4}\z/ }
      validates :card_expiration, format: { with: %r{\A\d{2}/\d{4}\z} }
      validates :card_cvc, format: { with: /\A\d{2,4}\z/, multiline: false }

      def order
        {
          amount: amount,
          ip: context.ip,
          email: current_user.email,
          card_number: credit_card_number,
          card_exp_month: credit_card_exp_month,
          card_exp_year: credit_card_exp_year,
          card_cvc: card_cvc,
          currency: Donations.currency,
          title: context.title,
          description: context.description
        }
      end

      private

      def credit_card_number
        card_number&.delete(" ")
      end

      def credit_card_exp_month
        (card_expiration || "")[0..1]
      end

      def credit_card_exp_year
        (card_expiration || "")[3..6]
      end
    end
  end
end
