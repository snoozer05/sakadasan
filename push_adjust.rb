#!/usr/bin/ruby

require "updater"
require "drb"

username = Updater::Username
ts = DRbObject.new_with_uri(Updater::DRbURI)

loop do
  if ts.read_all([:adjust, username]).size == 0
    ts.write([:adjust, username])
  end
  sleep 300
end
