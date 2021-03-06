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
    outgoing_response = access_token.get("http://api.twitter.com/1/friendships/outgoing.json")
    if outgoing_response.code != "200"
      next
    end
    friends = JSON.load(friends_response.body)
    followers = JSON.load(followers_response.body)
    outgoing = JSON.load(outgoing_response.body)
    ids_to_follow = followers - (friends & followers)
    ids_to_unfollow = friends - (friends & followers)
    ids_to_follow.each do |id_to_follow|
      if outgoing["ids"].include?(id_to_follow)
        next
      end
      param = {:user_id => id_to_follow}
      response = access_token.post("http://api.twitter.com/1/friendships/create/#{username}.json", param)
      if response.code == "200"
        logger.info("@#{username} has succeeded to follow id:#{id_to_follow}")
      else
        logger.warn("@#{username} has failed to follow id:#{id_to_follow}")
      end
    end
    ids_to_unfollow.each do |id_to_unfollow|
      param = {:user_id => id_to_unfollow}
      response = access_token.post("http://api.twitter.com/1/friendships/destroy.json", param)
      if response.code == "200"
        logger.info("@#{username} has succeeded to unfollow id:#{id_to_unfollow}")
      else
        logger.warn("@#{username} has failed to unfollow id:#{id_to_unfollow}")
      end
    end
  rescue => e
    logger.fatal("#{e.class}: #{e.message}")
    e.backtrace.each do |info|
      logger.fatal("-- #{info}")
    end
    next
  end
end
