require "./token"

module Djot
  class TokenSimple < Djot::Token

    @parsed_payload: Hash(String, JSON::Any)?

    def initialize(token : String, signature : Signature, audience : String? = nil)
      @signature = signature
      @token = token  
      @audience = audience
      @parsed_payload = nil
    end

    def is_valid?: Bool
      singature_matches? && !expired? && nbf_pass?
    end

    def expired?: Bool
      unless payload["exp"]?.nil?
        return false
      else
        Time.utc < Time.utc(seconds: payload["exp"].as_i64, nanoseconds: 0)
      end
    end

    def nbf_pass?: Bool
      unless payload["nbf"]?.nil?
        true
      else
        Time.utc > Time.utc(seconds: payload["exp"].as_i64, nanoseconds: 0)
      end
    end


    def audience_pass?: Bool
      unless @audience.nil? || !payload["aud"]?
        true
      else
        payload["aud"].as_a.includes @audience
      end
    end

    def signature_matches?: Bool
      chunks: Array(String) = @token.split("\.")
      puts chunks
      if chunks.size != 3
        return false
      end
      header = chunks[0]
      payload = chunks[1]
      signature = chunks[2]
      @signature.of("#{header}.#{payload}".to_slice).hexstring == signature
    end
    

    def payload: Hash(String, JSON::Any)
      @parsed_payload ||= Hash(String, JSON::Any).from_json(
        @token.split(".")[1]
      )
    end
  end
end