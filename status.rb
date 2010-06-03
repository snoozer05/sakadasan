require "connection"
require "zabuton_count"

class Status < ActiveRecord::Base
  class Receiver
    def initialize(username)
      @username = username
      @read = false
    end

    def read(tweet)
      if Status.find(
        :first,
        :conditions => ["status_id = ?", tweet["id"]])
        @read = true
      else
        @read = false
        status = Status.new
        status.status_id = tweet["id"]
        status.screen_name = tweet["user"]["screen_name"]
        status.text = tweet["text"]
        status.in_reply_to = tweet["in_reply_to_status_id"]
        status.save!
      end
      return nil
    end

    def read?
      return @read
    end
  end

  class Updater
    def tweet
    end

    def reply(tweet)
      zabuton_count = ZabutonCount.new
      return zabuton_count.get_zabuton(tweet["text"], tweet["user"]["screen_name"])
    end
  end
end
