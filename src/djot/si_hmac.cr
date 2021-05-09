require "openssl/hmac"
require "./signature"

module Djot
  class SiHmac < Djot::Signature
      @bits : Int32
      @key : String
      @algorithm: OpenSSL::Algorithm

    def initialize(key : String,  bits : Int = 256)
      case bits
      when 256
      @algorithm = :sha256
      when 384
      @algorithm = :sha384
      when 512
      @algorithm = :sha512
      else
      @algorithm = :sha256
      bits = 256
      end
      @bits = bits
      @key = key
    end

    def of(data : Bytes): Bytes
      OpenSSL::HMAC.digest(@algorithm, @key, data)
    end

    def name: String
      "HS#{@bits.to_s}"
    end
  end
end
