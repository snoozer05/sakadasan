# require "connection"
require "zabuton_count"

# class Status < ActiveRecord::Base
class Status
  class Receiver
    def initialize(username)
    end

    def read(tweet)
    end
  end

  class Updater
    def tweet
    end

    def reply(tweet)
      zabuton_count = ZabutonCount.new
      zabuton_count.get_zabuton(tweet["text"], tweet["user"]["screen_name"])
    end
  end
end
