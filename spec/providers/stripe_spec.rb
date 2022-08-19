# frozen_string_literal: true

require "spec_helper"
require "active_merchant"

module Decidim::Donations::Providers
  describe Stripe do
    subject { described_class.new settings }

    let(:settings) do
      {
        login: "some-login",
        publishable_key: "some-publishable-key"
      }
    end

    it "is multistep" do
      expect(subject.multistep?).to eq(false)
    end

    it "gateway is Stripe" do
      expect(subject.gateway).to be_a(ActiveMerchant::Billing::StripePaymentIntentsGateway)
      expect(subject.method).to eq("stripe")
      expect(subject.name).to eq("Stripe")
      expect(subject.form).to eq(Decidim::Donations::CreditCardCheckoutForm)
    end

    context "when settings are defined" do
      before do
        subject.amount = 12
        subject.transaction_id = "some-id"
        subject.order = "some-order"
      end

      it "returns amount in cents" do
        expect(subject.amount_in_cents).to eq(1200)
      end

      it "returns transaction hash" do
        expect(subject.transaction_hash).to eq("stripe-some-id")
      end
    end

    context "when processing orders" do
      let(:order) do
        {
          amount: 12,
          ip: "127.0.0.1",
          email: "test@example.org",
          card_number: "4242424242424242",
          card_exp_month: "10",
          card_exp_year: Time.current.next_year.to_s,
          card_cvc: "111",
          currency: "EUR",
          title: "some-title",
          description: "some-description"
        }
      end
      let(:params) do
        { amount: amount }
      end
      let(:response) do
        double(
          success?: response_success,
          message: "some message",
          params: { "id" => transaction_id }
        )
      end
      let(:purchase_order) do
        {
          currency: "EUR",
          amount: 1200,
          description: "some-title",
          payment_method_data: { billing_details: { email: "test@example.org" } },
          payment_method_types: ["card"],
          metadata: { ip: "127.0.0.1", email: "test@example.org", description: "some-description" }
        }
      end
      let(:success) { true }
      let(:response_success) { true }
      let(:amount) { 12 }
      let(:transaction_id) { "some-id" }
      let(:purchase) { subject.purchase(order: order, params: params) }

      before do
        allow(subject.gateway).to receive(:purchase).and_return(response)
      end

      it "purchase step sets the amount and transaction" do
        purchase
        expect(subject.amount).to eq(amount)
        expect(subject.transaction_id).to eq(transaction_id)
        expect(subject.order).to eq(purchase_order)
      end

      context "when unsuccessful response" do
        let(:response_success) { false }

        it "raises payment error" do
          expect { purchase }.to raise_error(Decidim::Donations::PaymentError)
        end
      end
    end
  end
end
