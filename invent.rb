#!/usr/bin/ruby

require "updater"
require "drb"
require "rubygems"
require "pit"
require "oauth"
require "json"
require "logger"

username = Updater::Username
ts = DRbObject.new_with_uri(Updater::DRbURI)

client_config = Pit.get(:client_xasymo)
user_config = Pit.get("twitter_#{username}".intern)
consumer = OAuth::Consumer.new(
  client_config[:consumer_key],
  client_config[:consumer_secret],
  :site => "http://twitter.com")
access_token = OAuth::AccessToken.new(
  consumer,
  user_config[:access_token],
  user_config[:access_token_secret])

logger = Logger.new("#{ENV["HOME"]}/log/#{username}.log")
logger.level = Logger::INFO

while ts.take([:invent, username])
  begin
    response = access_token.get("http://api.twitter.com/1/statuses/friends_timeline.json?count=200")
    if response.code == "200"
      tweets = JSON.load(response.body)
      tweets.reverse_each do |tweet|
        ts.write([:record, username, tweet])
      end
    else
      logger.warn("[#{Time.new.to_s}] invent.rb for @#{username}: response code #{response.code}")
      next
    end
  rescue => e
    logger.fatal("#{e.class}: #{e.message}")
    e.backtrace.each do |info|
      logger.fatal("-- #{info}")
    end
    next
  end
end
