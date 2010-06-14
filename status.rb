require "connection_establishment"

class Status < ActiveRecord::Base
  class Receiver
    def have_read?(tweet)
      if Status.find(
        :first,
        :conditions => ["status_id = ?", tweet["id"]])
        return true
      else
        status = Status.new
        status.status_id = tweet["id"]
        status.screen_name = tweet["user"]["screen_name"]
        status.text = tweet["text"]
        status.in_reply_to = tweet["in_reply_to_status_id"]
        status.save!
        return false
      end
    end
  end
end
