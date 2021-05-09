
module Djot
  abstract class Envelope
    abstract def wrap(payload): String
  end
end