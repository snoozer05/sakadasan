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

while ts.take([:adjust, username])
  begin
    friends_response = access_token.get("http://api.twitter.com/1/friends/ids.json")
    if friends_response.code != "200"
      next
    end
    followers_response = access_token.get("http://api.twitter.com/1/followers/ids.json")
    if followers_response.code != "200"
      next
    end
    friends = JSON.load(friends_response.body)
    followers = JSON.load(followers_response.body)
    ids_to_follow = followers - (friends & followers)
    ids_to_unfollow = friends - (friends & followers)
    ids_to_follow.each do |id_to_follow|
      param = {:user_id => id_to_follow}
      access_token.post("http://api.twitter.com/1/friendships/create/#{username}.json", param)
    end
    ids_to_unfollow.each do |id_to_unfollow|
      param = {:user_id => id_to_unfollow}
      access_token.post("http://api.twitter.com/1/friendships/destroy.json", param)
    end
  rescue => e
    logger.fatal("#{e.class}: #{e.message}")
    e.backtrace.each do |info|
      logger.fatal("-- #{info}")
    end
  end
end
