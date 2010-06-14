require "sakada"

class Updater < Sakada
  Username = "sakadasan"
  DRbURI = "druby://localhost:11111"
  alias :respond :carry_zabuton_by_tweet
end
