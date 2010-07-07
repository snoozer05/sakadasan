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

logger = Logger.new("#{ENV["HOME"]}/log/#{username}.log")
logger.level = Logger::INFO

while tuple = ts.take([:update, username, nil, nil])
  status = tuple[2]
  in_reply_to_status_id = tuple[3]
  param = {:status => status}
  if in_reply_to_status_id
    param[:in_reply_to_status_id] = in_reply_to_status_id
  end
  response = nil
  3.times do
    response = access_token.post("http://api.twitter.com/1/statuses/update.json", param)
    if response.code == "200"
      break
    end
  end
  if response.code != "200"
    logger.warn("@#{username} has failed to update: \"#{status}\"")
  end
end
