require 'twitter_fetcher'
require 'tweet_service'

class TweetsController < ApplicationController
  # not the best choice, as we'd need to redeploy to change auth, but
  # anything's better than nothing
  http_basic_authenticate_with name: 'stackem_packem_rackem', password: 'pr@sh@nt'

  def by
    @user_name = params['tweeter']
    @tweets    = TweetService.tweets_for(@user_name).map do |t|
      HtmlTweetPresenter.new(t)
    end
  end

  private

  ## we'll refactor and extract to lib/ or app/helpers if time allows
  class HtmlTweetPresenter
    attr_reader :user_name, :text, :timestamp

    def initialize(tweet)
      @user_name = if tweet.respond_to? :user_name
                     tweet.user_name
                   else
                     tweet.user.name
                   end
      @text      = tweet.text
      @timestamp = if tweet.respond_to? :timestamp
                     tweet.timestamp
                   else
                     tweet.created_at
                   end
    end
  end
end
