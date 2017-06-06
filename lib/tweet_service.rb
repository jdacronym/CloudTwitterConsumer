require_relative '../app/models/tweet'
require_relative 'twitter_fetcher'

module TweetService
  def self.tweets_for(user_name)
    tweets = Tweet.for(user_name)

    if tweets.first.nil? || tweets.first.created_at < (Time.now - 5.minutes)
      # delete stale tweets (inefficient, but there's only 25 at a time)
      Tweet.clear(user_name)
      # fetch new tweets
      tweets = TwitterFetcher.tweets_for(user_name)
      # persist tweets
      tweets.each do |t|
        Tweet.from(t)
      end
    else
      tweets
    end
  end
end
