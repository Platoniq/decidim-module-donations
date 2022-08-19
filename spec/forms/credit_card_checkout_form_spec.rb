# frozen_string_literal: true

require "spec_helper"

module Decidim::Donations
  describe CreditCardCheckoutForm do
    subject do
      described_class.from_params(
        attributes
      ).with_context(context)
    end

    let(:organization) { create :organization }
    let(:user) { create :user }
    let(:context) do
      {
        current_organization: organization,
        minimum_amount: nil,
        current_user: user
      }
    end
    let(:amount) { 15 }
    let(:card_number) { "4242 4242 4242 4242" }
    let(:card_expiration) { "08/2022" }
    let(:card_cvc) { "111" }
    let(:attributes) do
      {
        amount: amount,
        card_number: card_number,
        card_expiration: card_expiration,
        card_cvc: card_cvc
      }
    end
    let(:minimum_amount) { 5 }
    let(:default_amount) { 7 }

    before do
      Decidim::Donations.config.minimum_amount = minimum_amount
      Decidim::Donations.config.default_amount = default_amount
    end

    it { is_expected.to be_valid }

    it "returns a hash order" do
      expect(subject.order).to be_a(Hash)
      expect(subject.order[:amount]).to eq(amount)
      expect(subject.order[:card_number]).to eq("4242424242424242")
      expect(subject.order[:card_exp_month]).to eq("08")
      expect(subject.order[:card_exp_year]).to eq("2022")
      expect(subject.order[:card_cvc]).to eq(card_cvc)
    end

    shared_examples "argument invalid" do
      it {
        expect(subject).to be_invalid
      }
    end

    context "when no card number" do
      let(:card_number) { nil }

      it_behaves_like "argument invalid"
    end

    context "when empty card number" do
      let(:card_number) { "" }

      it_behaves_like "argument invalid"
    end

    context "when no spaced card number" do
      let(:card_number) { "4242424242424242" }

      it_behaves_like "argument invalid"
    end

    context "when too long card number" do
      let(:card_number) { "4242 4242 4242 4242 4242" }

      it_behaves_like "argument invalid"
    end

    context "when no card expiration" do
      let(:card_expiration) { nil }

      it_behaves_like "argument invalid"
    end

    context "when empty card expiration" do
      let(:card_expiration) { "" }

      it_behaves_like "argument invalid"
    end

    context "when no slash card expiration" do
      let(:card_expiration) { "082022" }

      it_behaves_like "argument invalid"
    end

    context "when too long card expiration" do
      let(:card_expiration) { "08/20225" }

      it_behaves_like "argument invalid"
    end

    context "when no card cvc" do
      let(:card_cvc) { nil }

      it_behaves_like "argument invalid"
    end

    context "when empty card cvc" do
      let(:card_cvc) { "" }

      it_behaves_like "argument invalid"
    end

    context "when too long card cvc" do
      let(:card_cvc) { "20225" }

      it_behaves_like "argument invalid"
    end
  end
end
