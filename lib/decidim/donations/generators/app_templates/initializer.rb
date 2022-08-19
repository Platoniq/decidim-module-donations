# frozen_string_literal: true

Rails.application.config.filter_parameters += [:card_number, :card_cvc, :card_exp_month, :card_exp_year]

Decidim::Verifications.register_workflow(:donations) do |workflow|
  workflow.engine = Decidim::Donations::Verification::Engine
  workflow.admin_engine = Decidim::Donations::Verification::AdminEngine

  # Next is optional (defaults to Non-renewable)
  # workflow.expires_in = 1.year
  # workflow.renewable = true
  # workflow.time_between_renewals = 1.month
end

Decidim::Donations.credentials do
  config.minimum_amount = 1
  config.verification_amount = 5 # if this config is omitted, defaults to minimum_amount
  config.default_amount = 10

  config.provider = :paypal_express # [:paypal_express, :stripe]
  config.credentials = {
    login: Rails.application.secrets.donations[:login],
    password: Rails.application.secrets.donations[:password],
    signature: Rails.application.secrets.donations[:signature]
  }
end
