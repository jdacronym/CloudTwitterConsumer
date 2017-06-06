require 'active_record'

class Tweet < ActiveRecord::Base
  def self.for(user)
    where(user_name: user).order(:created_at).all
  end

  def self.clear(user)
    where(user_name: user).delete_all
  end
    
  def self.from(tweet)
    Tweet.new.tap do |t|
      t.user      = tweet.user
      t.timestamp = tweet.created_at
      t.text      = tweet.text
      t.id        = tweet.id
    end.save
  end

  def user=(user)
    self.user_id = user.id
    self.user_name = user.screen_name
  end
end
