#!/usr/bin/ruby

require "status"
require "updater"
require "drb"

username = Updater::Username
ts = DRbObject.new_with_uri(Updater::DRbURI)

receiver = Status::Receiver.new

while tuple = ts.take([:record, username, nil])
  tweet = tuple[2]
  next if receiver.have_read?(tweet)
  ts.write([:read, username, tweet])
end
