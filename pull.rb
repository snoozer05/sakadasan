#!/usr/bin/ruby

require "updater"
require "drb"

username = Updater::Username
ts = DRbObject.new_with_uri(Updater::DRbURI)

loop do
  if ts.read_all([:invent, username]).size == 0
    ts.write([:invent, username])
  end
  sleep 60
end
