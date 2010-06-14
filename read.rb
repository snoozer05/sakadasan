#!/usr/bin/ruby

require "sakada"
require "drb"

username = Updater::Username
ts = DRbObject.new_with_uri(Updater::DRbURI)

updater = Updater.new

while tuple = ts.take([:read, username, nil])
  tweet = tuple[2]
  responses = updater.respond(tweet["text"], tweet["user"]["screen_name"])
  responses.each do |response|
    ts.write([:update, username, response, tweet["id"]])
  end
end
