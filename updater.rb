require "sakada"

class Updater < Sakada
  Username = "sakadasan"
  DRbURI = "druby://localhost:11111"
  alias :respond :zabuton_by_tweet
end
