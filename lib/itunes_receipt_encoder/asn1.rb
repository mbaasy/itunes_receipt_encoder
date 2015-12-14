require 'openssl'
require 'itunes_receipt_encoder/asn1/sequence'

##
# ItunesReceiptEncoder
module ItunesReceiptEncoder
  ##
  # ItunesReceiptEncoder::ASN1
  module ASN1
    ASN1_VERSION = 1

    def self.sequence(value, encoding, type = nil)
      Sequence.new(value, encoding, type).to_seq
    end

    def self.set(array)
      OpenSSL::ASN1::Set.new(array.compact)
    end

    def self.time(time)
      time && time.utc.strftime('%FT%TZ')
    end
  end
end
