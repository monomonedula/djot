require "json"


module Djot
  extend self

  class EnvelopeExp < Djot::Envelope
    def initialize(envelope : Envelope, lifespan : Time::Span = Time::Span.new(hours: 24))
      @origin = envelope
      @lifespan = lifespan
    end
  
    def wrap(payload): String
        @origin.wrap(
          payload.merge(
            {
              "exp" => (Time.utc.now + @lifespan).to_unix
            }
          )
        )
    end
  end
end



