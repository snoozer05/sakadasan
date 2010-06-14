#!/usr/bin/ruby

require "updater"
require "drb"
require "rubygems"
require "pit"
require "oauth"
require "json"

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

while ts.take([:adjust, username])
  begin
    friends_response = access_token.get("http://api.twitter.com/1/friends/ids.json")
    friends = JSON.load(friends_response.body)
    followers_response = access_token.get("http://api.twitter.com/1/followers/ids.json")
    followers = JSON.load(followers_response.body)
  rescue Exception
    next
  end
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
end
