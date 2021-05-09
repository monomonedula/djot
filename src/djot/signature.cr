module Djot
  abstract class Signature
    abstract def of(data : Bytes): Bytes
    abstract def name: String
  end
end