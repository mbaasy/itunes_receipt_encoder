require 'openssl'

##
# ItunesReceiptEncoder
module ItunesReceiptEncoder
  ##
  # ItunesReceiptEncoder::ASN1
  module ASN1
    ##
    # ItunesReceiptEncoder::ASN1::Sequence
    class Sequence
      attr_reader :encoding, :type

      def initialize(value, type, encoding = nil)
        @value = value
        @encoding = encoding
        @type = type
      end

      def value
        case encoding
        when :utf8_string
          OpenSSL::ASN1::UTF8String.new(@value.to_s).to_der
        when :ia5_string
          OpenSSL::ASN1::IA5String.new(@value.to_s).to_der
        when :integer
          OpenSSL::ASN1::Integer.new(OpenSSL::BN.new(@value.to_s)).to_der
        else
          @value
        end
      end

      def to_seq
        OpenSSL::ASN1::Sequence.new([
          OpenSSL::ASN1::Integer.new(OpenSSL::BN.new(type.to_s)),
          OpenSSL::ASN1::Integer.new(OpenSSL::BN.new(ASN1_VERSION.to_s)),
          OpenSSL::ASN1::OctetString.new(value.to_s)
        ])
      end
    end
  end
end
