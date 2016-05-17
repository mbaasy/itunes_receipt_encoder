require 'pp'

describe ItunesReceiptEncoder do
  def random_time
    Time.now.utc + rand(86_400..31_536_000)
  end

  def random_id
    rand(100_000_000_000_000..999_999_999_999_999)
  end

  describe 'decoding' do
    subject { ItunesReceiptDecoder.new(receipt) }

    let(:bundle_id) do
      "#{FFaker::Internet.domain_suffix}.#{FFaker::Internet.domain_word}.ios"
    end
    let(:environment) { 'Production' }
    let(:application_version) { rand(1..10).to_s + '.0' }
    let(:original_application_version) { rand(1..10) }
    let(:creation_date) { random_time }
    let(:expiration_date) { creation_date + 31_536_000 }
    let(:in_app) do
      Array.new(rand(3..6)).map do |i|
        {
          quantity: rand(1..10),
          product_id: FFaker::Internet.domain_word + i.to_s,
          transaction_id: random_id,
          original_transaction_id: random_id,
          purchase_date: random_time,
          original_purchase_date: random_time,
          expires_date: random_time,
          cancellation_date: random_time,
          web_order_line_item_id: random_id
        }
      end
    end
    let(:attrs) do
      {
        bundle_id: bundle_id,
        environment: environment,
        application_version: application_version,
        original_application_version: original_application_version,
        creation_date: creation_date.to_i,
        expiration_date: expiration_date.strftime('%FT%TZ'),
        in_app: in_app
      }
    end

    describe '#to_unified' do
      let(:receipt) { described_class.new(attrs).to_unified }

      it 'creates a unified style receipt' do
        expect(subject.style).to eq(:unified)
      end

      context do
        subject { super().receipt }

        it 'sets receipt properties' do
          expect(subject[:bundle_id]).to eq(bundle_id)
          expect(subject[:environment]).to eq(environment)
          expect(subject[:application_version]).to eq(application_version.to_s)
          expect(subject[:original_application_version])
            .to eq(original_application_version.to_s)
          expect(subject[:creation_date])
            .to eq(creation_date.strftime('%FT%TZ'))
          expect(subject[:expiration_date])
            .to eq(expiration_date.strftime('%FT%TZ'))
        end

        it 'sets the in_app properties' do
          in_app.each_with_index do |in_app, index|
            expect(subject[:in_app][index][:quantity])
              .to eq(in_app[:quantity])
            expect(subject[:in_app][index][:product_id])
              .to eq(in_app[:product_id])
            expect(subject[:in_app][index][:transaction_id])
              .to eq(in_app[:transaction_id].to_s)
            expect(subject[:in_app][index][:original_transaction_id])
              .to eq(in_app[:original_transaction_id].to_s)
            expect(subject[:in_app][index][:purchase_date])
              .to eq(in_app[:purchase_date].strftime('%FT%TZ'))
            expect(subject[:in_app][index][:purchase_date])
              .to eq(in_app[:purchase_date].strftime('%FT%TZ'))
            expect(subject[:in_app][index][:original_purchase_date])
              .to eq(in_app[:original_purchase_date].strftime('%FT%TZ'))
            expect(subject[:in_app][index][:expires_date])
              .to eq(in_app[:expires_date].strftime('%FT%TZ'))
            expect(subject[:in_app][index][:cancellation_date])
              .to eq(in_app[:cancellation_date].strftime('%FT%TZ'))
            expect(subject[:in_app][index][:web_order_line_item_id])
              .to eq(in_app[:web_order_line_item_id])
          end
        end
      end
    end

    describe '#to_transaction' do
      let(:receipt) { described_class.new(attrs).to_transaction(options) }
      let(:index) { 2 }
      let(:options) { { index: index } }

      it 'creates a transaction style receipt' do
        expect(subject.style).to eq(:transaction)
      end

      context do
        subject { super().receipt }

        it 'sets receipt properties' do
          expect(subject[:bid]).to eq(bundle_id)
          expect(subject[:bvrs]).to eq(application_version)
          expect(subject[:quantity]).to eq(in_app[index][:quantity])
          expect(subject[:product_id]).to eq(in_app[index][:product_id])
          expect(subject[:transaction_id]).to eq(in_app[index][:transaction_id])
          expect(subject[:web_order_line_item_id])
            .to eq(in_app[index][:web_order_line_item_id])
          expect(subject[:original_transaction_id])
            .to eq(in_app[index][:original_transaction_id])
        end
      end
    end
  end
end
