require "./header"

module Djot
  class SimpleHeader < Djot::Header
    def initialize(signature : Signature)
      initialize(signature, {} of String => String)
    end

    def initialize(signature : Signature, extra : Hash(String, String))
      @signature = signature
      @extra = extra
    end

    def as_string: String
      {"alg" => @signature.name, "typ" => "JWT"}.merge(@extra).to_json
    end
  end
end