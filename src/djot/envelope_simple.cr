require "json"


module Djot
  extend self

  class EnvelopeSimple
    def initialize(signature : Signature)
      initialize(signature, SimpleHeader.new(signature))
    end
  
    def initialize(signature : Signature, header_extra : Hash(String, String))
      initialize(signature, SimpleHeader.new(signature, header_extra), payload)
    end
  
    def initialize(signature : Signature, header : Djot::Header)
      @signature = signature
      @header = header
    end
  
    def wrap(payload): String
        header_encoded = Base64.urlsafe_encode(@header.as_string, false)
        payload_encoded = Base64.urlsafe_encode(payload.to_json, false)
        signature = @signature.of("#{header_encoded}.#{payload_encoded}".to_slice).hexstring
        "#{header_encoded}.#{payload_encoded}.#{signature}"
    end
  end
end



