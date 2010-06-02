# require "connection"
require "zabuton_count"

# class Status < ActiveRecord::Base
class Status
  class Receiver
    def initialize
      @to_reply_flag = false
    end

    def read(tweet)
      @to_reply_flag =
        if tweet["text"][/@(\w+)\s*(\+\++|--+)/]
          true
        else
          false
        end
    end

    def to_reply?
      @to_reply_flag
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
