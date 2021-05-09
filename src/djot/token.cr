module Djot
  abstract class Token
    abstract def is_valid?: Bool
    abstract def payload: Hash(String, JSON::Any)
  end
end