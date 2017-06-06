require 'twitter'

module TwitterFetcher
  def self.api_key
    'Uc7TDwDP2DRzoe5XsIGUsG3DE'
  end

  def self.api_secret
    'qTy3IzD31Q0tTMQQ5DYJB8aao9Dfj0aBOD8xzh5rx2WRX8oNJO'
  end

  def self.config
    {consumer_key: api_key, consumer_secret: api_secret}
  end

  def self.tweets_for(user)
    client = Twitter::REST::Client.new(TwitterFetcher.config)
    client.user_timeline(user, count: 25)
  end
end
