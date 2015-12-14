# iTunes Receipt Encoder

Encodes receipt data into iTunes encoded receipts and exports as [appStoreReceiptURL](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSBundle_Class/index.html#//apple_ref/occ/instm/NSBundle/appStoreReceiptURL) or [transactionReceipt](https://developer.apple.com/library/ios/documentation/StoreKit/Reference/SKPaymentTransaction_Class/index.html#//apple_ref/occ/instp/SKPaymentTransaction/transactionReceipt) formats.

[![Code Climate](https://codeclimate.com/github/mbaasy/itunes_receipt_encoder/badges/gpa.svg)](https://codeclimate.com/github/mbaasy/itunes_receipt_encoder)
[![Test Coverage](https://codeclimate.com/github/mbaasy/itunes_receipt_encoder/badges/coverage.svg)](https://codeclimate.com/github/mbaasy/itunes_receipt_encoder/coverage)
[![Build Status](https://travis-ci.org/mbaasy/itunes_receipt_encoder.svg?branch=master)](https://travis-ci.org/mbaasy/itunes_receipt_encoder)
[![Gem Version](https://badge.fury.io/rb/itunes_receipt_encoder.svg)](https://badge.fury.io/rb/itunes_receipt_encoder)
[![Dependency Status](https://gemnasium.com/mbaasy/itunes_receipt_encoder.svg)](https://gemnasium.com/mbaasy/itunes_receipt_encoder)


## Install

Install from the command line:

```sh
$ gem install itunes_receipt_encoder
```

Or include it in your Gemfile:

```ruby
gem 'itunes_receipt_encoder'
```

## Usage

```ruby
require 'itunes_receipt_encoder'

encoder = ItunesReceiptEncoder.new(
  bundle_id: 'com.mbaasy.ios',
  environment: 'Production',
  application_version: '1.0',
  original_application_version: '1.0',
  creation_date: Time.now,
  in_app:
  [{
    quantity: 1,
    product_id: 'premium',
    transaction_id: 582591442087453,
    original_transaction_id: 582591442087453,
    purchase_date: Time.now,
    original_purchase_date: Time.now,
    expires_date: Time.now + (60 * 60 * 24 * 30),
    web_order_line_item_id: 566905420318744
  }, {
    quantity: 1,
    product_id: 'extra-life',
    transaction_id: 970762356111308,
    original_transaction_id: 223608664143082,
    purchase_date: Time.now,
    original_purchase_date: Time.now
  }]
)

encoder.to_unified # => appStoreReceiptURL receipt

encoder.to_transaction # => transactionReceipt receipt

```

#### encoder.to_unified([options = {}])

Returns a unified style receipt, corresponding to the [appStoreReceiptURL](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSBundle_Class/index.html#//apple_ref/occ/instm/NSBundle/appStoreReceiptURL).

##### Options:

`:cert` - SSL certicicate to create the P7 payload.

`:key` - SSL private key to create the P7 payload.

`:raw` - Boolean, if true returns the raw P7 payload, otherwise returns a encoded Base64 string.

#### encoder.to_transaction([options = {}])

Returns a transaction style receipt, corresponding to the [transactionReceipt](https://developer.apple.com/library/ios/documentation/StoreKit/Reference/SKPaymentTransaction_Class/index.html#//apple_ref/occ/instp/SKPaymentTransaction/transactionReceipt).

##### Options:

`:raw` - Boolean, if true returns the raw plist, otherwise returns a Base64 encoded string.

`:index` - Integer, if set will use the specific index in the `in_app` array for the receipt, otherwise it will use the first one.

`:no_ms_dates` - Boolean, if true it will exclude millisecond timestamps from the result.

`:no_pst_dates` - Boolean, if true it will exclude PST timestamps from the results.

---

Copyright 2015 [mbaasy.com](https://mbaasy.com/). This project is subject to the [MIT License](/LICENSE).
