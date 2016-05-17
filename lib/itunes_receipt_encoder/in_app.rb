require 'itunes_receipt_encoder/utils'
require 'itunes_receipt_encoder/asn1'

##
# ItunesReceiptEncoder
module ItunesReceiptEncoder
  ##
  # ItunesReceiptEncoder::InApp
  class InApp
    include Utils

    attr_accessor :quantity, :product_id, :transaction_id,
                  :original_transaction_id, :web_order_line_item_id, :item_id

    timestamp_accessor :purchase_date, :original_purchase_date, :expires_date,
                       :cancellation_date

    def initialize(attrs = {})
      attrs.each { |key, val| send("#{key}=", val) }
    end

    def to_asn1_set
      ASN1.set [
        asn1_quantity,
        asn1_product_id,
        asn1_transaction_id,
        asn1_original_transaction_id,
        asn1_web_order_line_item_id,
        (asn1_purchase_date if purchase_date),
        (asn1_original_purchase_date if original_purchase_date),
        (asn1_expires_date if expires_date),
        (asn1_cancellation_date if cancellation_date)
      ]
    end

    def to_plist_hash(options = {})
      hash = {
        'quantity' => quantity,
        'product-id' => product_id,
        'item-id' => item_id,
        'transaction-id' => transaction_id,
        'original_transaction-id' => original_transaction_id,
        'web-order-line-item-id' => web_order_line_item_id,
        'purchase-date' => gmt_time(purchase_date),
        'original-purchase-date' => gmt_time(original_purchase_date),
        'expires-date-formatted' => gmt_time(expires_date)
      }
      hash.merge!(
        'purchase-date-ms' => ms_time(purchase_date),
        'original-purchase_date_ms' => ms_time(original_purchase_date),
        'expires-date' => gmt_time(expires_date)
      ) unless options[:no_ms_dates]
      hash.merge!(
        'purchase-date-pst' => pst_time(purchase_date),
        'original-purchase-date-pst' => pst_time(original_purchase_date),
        'expires-date-pst' => pst_time(expires_date)
      ) unless options[:no_pst_dates]
      hash
    end

    private

    def asn1_quantity
      ASN1.sequence quantity, 1701, :integer
    end

    def asn1_product_id
      ASN1.sequence product_id, 1702, :utf8_string
    end

    def asn1_transaction_id
      ASN1.sequence transaction_id, 1703, :utf8_string
    end

    def asn1_original_transaction_id
      ASN1.sequence original_transaction_id, 1705, :utf8_string
    end

    def asn1_web_order_line_item_id
      ASN1.sequence web_order_line_item_id || 0, 1711, :integer
    end

    def asn1_purchase_date
      ASN1.sequence asn1_time(purchase_date), 1704, :ia5_string
    end

    def asn1_original_purchase_date
      ASN1.sequence asn1_time(original_purchase_date), 1706, :ia5_string
    end

    def asn1_expires_date
      ASN1.sequence asn1_time(expires_date), 1708, :ia5_string
    end

    def asn1_cancellation_date
      ASN1.sequence asn1_time(cancellation_date), 1712, :ia5_string
    end
  end
end
