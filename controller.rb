class Controller
  def initialize(username)
    require "drb"
    require "rubygems"
    require "pit"
    require "oauth"
    @username = username
    DRb.start_service
    @ts = DRbObject.new_with_uri("druby://localhost:11111")
    client_config = Pit.get(:client_xasymo)
    user_config = Pit.get("twitter_#{@username}".intern)
    consumer = OAuth::Consumer.new(
      client_config[:consumer_key],
      client_config[:consumer_secret],
      :site => "http://twitter.com")
    @access_token = OAuth::AccessToken.new(
      consumer,
      user_config[:access_token],
      user_config[:access_token_secret])
  end

  def pull
    loop do
      sleep 60
      next if @ts.read_all([:invent, @username]).size > 0
      @ts.write([:invent, @username])
    end
  end

  def invent
    require "rubygems"
    require "json"
    while @ts.take([:invent, @username])
      begin
        response = @access_token.get("http://api.twitter.com/1/statuses/friends_timeline.json?count=200")
        tweets = JSON.load(response.body)
      rescue Exception
        next
      end
      tweets.each do |tweet|
        @ts.write([:read, @username, tweet])
      end
    end
  end

  def read
    require "status"
    receiver = Status::Receiver.new(@username)
    while tuple = @ts.take([:read, @username, nil])
      tweet = tuple[2]
      receiver.read(tweet)
      @ts.write([:reply, @username, tweet])
    end
  end

  def reply
    require "status"
    updater = Status::Updater.new
    while tuple = @ts.take([:reply, @username, nil])
      tweet = tuple[2]
      if text = updater.reply(tweet)
        status = "@#{tweet["user"]["screen_name"]} #{text}"
        @ts.write([:update, @username, status, tweet["id"]])
      end
    end
  end

  def push_tweet
    sleep
    # loop do
    #   sleep 900
    #   next if @ts.read_all([:tweet, @username]).size > 0
    #   @ts.write([:tweet, @username])
    # end
  end

  def tweet
    require "status"
    updater = Status::Updater.new
    while @ts.take([:tweet, @username])
      status = updater.tweet
      @ts.write([:update, @username, status, nil])
    end
  end

  def update
    while tuple = @ts.take([:update, @username, nil, nil])
      status = tuple[2]
      in_reply_to_status_id = tuple[3]
      param = {:status => status}
      if in_reply_to_status_id
        param[:in_reply_to_status_id] = in_reply_to_status_id
      end
      @access_token.post("http://api.twitter.com/1/statuses/update.json", param)
    end
  end

  def push_adjust
    loop do
      sleep 180
      next if @ts.read_all([:adjust, @username]).size > 0
      @ts.write([:adjust, @username])
    end
  end

  def adjust
    require "rubygems"
    require "json"
    while @ts.take([:adjust, @username])
      begin
        friends_response = @access_token.get("http://api.twitter.com/1/friends/ids.json")
        friends = JSON.load(friends_response.body)
        followers_response = @access_token.get("http://api.twitter.com/1/followers/ids.json")
        followers = JSON.load(followers_response.body)
      rescue Exception
        next
      end
      ids_to_follow = followers - (friends & followers)
      ids_to_unfollow = friends - (friends & followers)
      ids_to_follow.each do |id_to_follow|
        param = {:user_id => id_to_follow}
        @access_token.post("http://api.twitter.com/1/friendships/create/#{@username}.json", param)
      end
      ids_to_unfollow.each do |id_to_unfollow|
        param = {:user_id => id_to_unfollow}
        @access_token.post("http://api.twitter.com/1/friendships/destroy.json", param)
      end
    end
  end
end
