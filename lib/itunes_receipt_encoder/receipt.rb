require 'base64'
require 'cfpropertylist'
require 'itunes_receipt_encoder/payload'

##
# ItunesReceiptEncoder
module ItunesReceiptEncoder
  ##
  # ItunesReceiptEncoder::Receipt
  class Receipt
    PRIVATE_KEY = <<-EOF.freeze
-----BEGIN RSA PRIVATE KEY-----
MIICXgIBAAKBgQCwFAFtL0PVWIAhkZGvOieoG+FYbSxGsQZ+oj8p71kSIPj4zo1/
tNAB4hZZkhNUcys1WXb1AK5dXlMs4AwK6zIANvlwJxu4fBIW+sENc4yHaJWfcZJR
tgX35aWzAPTSjy/ChsYGwV9eVHNN1iG47E5vwLYH7B8xmagK8ame5cNIhwIDAQAB
AoGBAK8VhYGbYRkw4l/+zt1tt2c7Ke1yyXcVqj6beLFrNaeIL+nAAgW9tqRYux6f
2Sa9SnbHGjlvTvK6y3ww4OiujEzxRO/0ERUk49bkKt/wmEgBpp76mNcoosBu21Gq
p/C9NGkqqvV31nDhcgqYBAqI7Yc2d0vsUV4pPBw8tGl4yjKpAkEA4lTYxtXn7y2j
TFOQvmQkctqwC1zi2OtvP4uo3llnLsE1ffIQYk8c1jBXChiGgT7v2frZIv+fIUk/
DSxUEkDG7QJBAMcoxq91664GOZSsmZJK6R8uDbOrQ/PGTSrBfvwPP/CtUSJotaP2
qOFl8CttDs7DJbS6mY5oplNjN8s0MknwisMCQA13FMqHkVvmcC+rTRI2rQB0SEL0
zL4xC5ZRPcO0t/HNJtyOWTEwGbwYdiUwnlf0IZrrVJ3DbXkyfWDQQVQwrGUCQQCT
7T+Wd/n0Kn9+ZK00shtxo11eBGnWmYYbqdlOE22ksLdA3ZF9FerecD7xonGLNfu9
v5Pq6OQRr/JzJnPr45TNAkEAkqll2DUKWTKiva4MPvda30vZFbraRkW0WUWNIara
RDUtoqjlu22PZhexNT4aulrb7OVBxq4yjqdGq5Kgo1z8mw==
-----END RSA PRIVATE KEY-----
EOF
    CERTIFICATE = <<-EOF.freeze
-----BEGIN CERTIFICATE-----
MIIC3jCCAkegAwIBAgIJAN0obOgx+IbBMA0GCSqGSIb3DQEBBQUAMFQxCzAJBgNV
BAYTAkRFMQ8wDQYDVQQIEwZCZXJsaW4xDzANBgNVBAcTBkJlcmxpbjEjMCEGA1UE
ChMabWJhYXN5IG1vYmlsZSBzb2x1dGlvbnMgVUcwHhcNMTUxMjExMTczNjU3WhcN
MTYxMjEwMTczNjU3WjBUMQswCQYDVQQGEwJERTEPMA0GA1UECBMGQmVybGluMQ8w
DQYDVQQHEwZCZXJsaW4xIzAhBgNVBAoTGm1iYWFzeSBtb2JpbGUgc29sdXRpb25z
IFVHMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCwFAFtL0PVWIAhkZGvOieo
G+FYbSxGsQZ+oj8p71kSIPj4zo1/tNAB4hZZkhNUcys1WXb1AK5dXlMs4AwK6zIA
NvlwJxu4fBIW+sENc4yHaJWfcZJRtgX35aWzAPTSjy/ChsYGwV9eVHNN1iG47E5v
wLYH7B8xmagK8ame5cNIhwIDAQABo4G3MIG0MB0GA1UdDgQWBBRWJ8qIehJu60Jt
8QDfEjx/BZIFqTCBhAYDVR0jBH0we4AUVifKiHoSbutCbfEA3xI8fwWSBamhWKRW
MFQxCzAJBgNVBAYTAkRFMQ8wDQYDVQQIEwZCZXJsaW4xDzANBgNVBAcTBkJlcmxp
bjEjMCEGA1UEChMabWJhYXN5IG1vYmlsZSBzb2x1dGlvbnMgVUeCCQDdKGzoMfiG
wTAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBBQUAA4GBABBYeC04N2OMT5pPEeC2
Ckl6J9RkVghCz/LurxcqWXzZvt4SbBhKTGRxoIGKIbtkz8Kk3MoCH2/HwSNd56+W
LRZiVl2m9xTwOjNmZI2hqe8Ps3oY5IJyPp/9A6OQqVCB59zW2Br547Su+5hhxRcX
iZxrB9LI1CXppp9/9b8D0vYf
-----END CERTIFICATE-----
EOF

    attr_reader :payload

    def initialize(attrs = {})
      @payload = Payload.new(attrs)
      yield self if block_given?
    end

    def to_unified(options = {})
      receipt = OpenSSL::PKCS7.sign(
        OpenSSL::X509::Certificate.new(options.fetch(:cert, CERTIFICATE)),
        OpenSSL::PKey::RSA.new(options.fetch(:key, PRIVATE_KEY)),
        payload.to_asn1_set.to_der,
        [],
        OpenSSL::PKCS7::BINARY
      ).to_der
      options[:raw] ? receipt : [receipt].pack('m0')
    end

    def to_transaction(options = {})
      data = {
        'purchase-info' => purchase_info_plist(options),
        'signature' => options.fetch(:signature, 'unsigned'),
        'pod' => options.fetch(:pod, 100),
        'signing-status' => options.fetch(:signing_status, 0)
      }
      data['environment'] = payload.environment unless
        payload.environment == 'Production'
      plist = CFPropertyList::List.new
      plist.value = CFPropertyList.guess data
      receipt = plist.to_str(CFPropertyList::List::FORMAT_PLAIN)
      options[:raw] ? receipt : [receipt].pack('m0')
    end

    private

    def purchase_info_plist(options)
      plist = CFPropertyList::List.new
      plist.value = CFPropertyList.guess payload.to_plist_hash(options)
      purchase_info = plist.to_str(CFPropertyList::List::FORMAT_PLAIN)
      [purchase_info].pack('m0')
    end
  end
end
