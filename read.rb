#!/usr/bin/ruby

require "updater"
require "drb"
require "logger"

username = Updater::Username
ts = DRbObject.new_with_uri(Updater::DRbURI)

updater = Updater.new
log = Logger.new("#{ENV["HOME"]}/log/sakadasan.log")
log.level = Logger::INFO

while tuple = ts.take([:read, username, nil])
  log.debug("@#{username}'s read.rb got the trigger")
  begin
    tweet = tuple[2]
    responses = updater.respond(tweet["text"], tweet["user"]["screen_name"])
    log.debug("@#{username} responded to some tweet")
    responses.each do |response|
      ts.write([:update, username, response, tweet["id"]])
      log.info("@#{username} said \"#{response}\" (in reply to @#{tweet["user"]["screen_name"]})")
    end
  rescue => e
    log.fatal("#{e.class}: #{e.message}")
    e.backtrace.each do |info|
      log.fatal("-- #{info}")
    end
  end
end
