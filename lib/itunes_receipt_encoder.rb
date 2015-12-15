require 'itunes_receipt_encoder/version'
require 'itunes_receipt_encoder/receipt'

##
# ItunesReceiptEncoder
module ItunesReceiptEncoder
  def self.new(attrs = {}, &block)
    Receipt.new(attrs, &block)
  end
end
