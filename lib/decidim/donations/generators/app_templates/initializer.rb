# frozen_string_literal: true

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

  config.provider = :paypal_express # [:paypal_express, :stripe_express] are the only providers supported
  config.credentials = {
    login: sk_test_51LVAMpFmqwVqTUhDO0axDC9r707qg4SdO4WlS6qvfnimHp90QYkIw76w9ZKkWJcrJM2NC6J8qIdz2aBpke9mFeFa00wI8AlrOJ,
    publishable_key: pk_test_51LVAMpFmqwVqTUhDmm0GfEXZF55hZXtAPgFWIPAlYsvoEidB2LcUibFeUgBvByI2sHJ5pd7xFwhw2vhSk90noCHA00GAHfTBEX
  }
end
