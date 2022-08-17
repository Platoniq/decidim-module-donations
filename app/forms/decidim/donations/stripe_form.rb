# frozen_string_literal: true

module Decidim
  module Donations
    class StripeForm < Form
      attribute :amount, Integer, default: Donations.config.default_amount
      attribute :publishable_key, String, default: Donations.config.publishable_key
      attribute :name
      attribute :month
      attribute :year
      attribute :brand
      attribute :number
      attribute :verification_value
    end
  end
end
