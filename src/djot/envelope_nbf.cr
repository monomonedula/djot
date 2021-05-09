require "json"


module Djot
  extend self

  class EnvelopeNbf < Djot::Envelope
    def initialize(envelope : Envelope, delay : Time::Span = Time::Span.new(hours: 24))
      @origin = envelope
      @delay = delay
    end
  
    def wrap(payload): String
        @origin.wrap(
          payload.merge(
            {
              "nbf" => (Time.utc.now + @delay).to_unix,
              "iat" => Time.utc.now.to_unix
            }
          )
        )
    end
  end
end
