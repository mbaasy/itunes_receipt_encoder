describe 'cmd line' do
  subject { `bin/itunes_receipt_encoder #{options} #{file}` }
  let(:file) { 'spec/fixtures/cmd_line_example.json' }
  let(:options) { '' }

  context 'decoding' do
    subject { ItunesReceiptDecoder.new(super()) }

    describe '--style unified' do
      let(:options) { '--style unified' }

      it 'returns a unified style receipt' do
        expect(subject.style).to eq(:unified)
      end
    end

    describe '--style transaction' do
      let(:options) { '--style transaction' }

      it 'returns a transation style receipt' do
        expect(subject.style).to eq(:transaction)
      end
    end
  end
end
