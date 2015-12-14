require 'itunes_receipt_encoder/utils'
require 'itunes_receipt_encoder/in_app'
require 'itunes_receipt_encoder/asn1'

##
# ItunesReceiptEncoder
module ItunesReceiptEncoder
  ##
  # ItunesReceiptEncoder::Payload
  class Payload
    include Utils

    attr_accessor :environment, :bundle_id, :application_version,
                  :original_application_version, :creation_date,
                  :expiration_date, :opaque_value, :sha1_hash, :in_app,
                  :unique_vendor_identifier

    def initialize(attrs = {})
      attrs.each { |key, val| send("#{key}=", val) }
      @in_app ||= []
      yield self if block_given?
    end

    def to_asn1_set
      ASN1.set [
        asn1_environment,
        asn1_bundle_id,
        asn1_application_version,
        asn1_original_application_version,
        asn1_creation_date,
        (asn1_opaque_value if opaque_value),
        (asn1_sha1_hash if sha1_hash),
        (asn1_expiration_date if expiration_date)
      ].concat(asn1_in_app)
    end

    def to_plist_hash(options = {})
      transaction = InApp.new(in_app[options.fetch(:index, 0)])
      {
        'bid' => bundle_id.to_s,
        'bvrs' => application_version.to_s,
        'unique-vendor-identifier' => unique_vendor_identifier.to_s
      }.merge(transaction.to_plist_hash(options))
    end

    private

    def asn1_environment
      ASN1.sequence environment, 0, :utf8_string
    end

    def asn1_bundle_id
      ASN1.sequence bundle_id, 2, :utf8_string
    end

    def asn1_application_version
      ASN1.sequence application_version, 3, :utf8_string
    end

    def asn1_opaque_value
      ASN1.sequence opaque_value, 4
    end

    def asn1_sha1_hash
      ASN1.sequence sha1_hash, 5
    end

    def asn1_original_application_version
      ASN1.sequence original_application_version, 19, :utf8_string
    end

    def asn1_creation_date
      ASN1.sequence ASN1.time(creation_date), 12, :ia5_string
    end

    def asn1_expiration_date
      ASN1.sequence ASN1.time(expiration_date), 21, :ia5_string
    end

    def asn1_in_app
      in_app.map do |in_app|
        ASN1.sequence InApp.new(in_app).to_asn1_set.to_der, 17
      end
    end
  end
end
