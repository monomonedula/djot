
module Djot
  abstract class Payload
    abstract def to_json
  end


  class PayloadSimple < Payload
    def initialize(**keys)
      @keys = keys    
    end

    def to_json
      @keys.to_json
    end
  end
end