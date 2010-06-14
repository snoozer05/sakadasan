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

while ts.take([:invent, username])
  begin
    response = access_token.get("http://api.twitter.com/1/statuses/friends_timeline.json?count=200")
    tweets = JSON.load(response.body)
  rescue Exception
    next
  end
  tweets.reverse_each do |tweet|
    ts.write([:record, username, tweet])
  end
end
