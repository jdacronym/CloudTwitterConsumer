require 'rails_helper'

RSpec.describe TweetsController, type: :controller do
  describe '#index' do
    let(:response) { get :index }

    it 'succeeds' do
      expect(response.status).to eql 200
    end
  end

  describe '#by' do
    let(:mock_tweet) { Struct.new(:text, :created_at, :user) }
    let(:mock_db_tweet) { Struct.new(:id, :text, :user_id, :user_name, :timestamp, :created_at) }
    let(:text) { "I'm a tweeter!" }

    let(:created) { Time.now - 10.minutes }
    let(:tweeted_at) { Time.now - 10.minutes }
    let(:saved_at) { Time.now - 2.minutes }

    let(:user_name) { 'rando_calrissian' }
    let(:user) { Struct.new(:name, :id).new(user_name, 1337) }
    let(:tweet) { mock_tweet.new(text, created, user) }
    let(:db_tweet) { mock_db_tweet.new(10001, text, 1337, user_name, tweeted_at, saved_at) }

    let(:response) { get 'by', params: { tweeter: user_name } }
    let(:no_tweets) { [] }

    let :many_tweets do
      (0..24).collect do |i|
        tweet.dup.tap { |t| t.created_at = tweeted_at - (10 * i).minutes }
      end
    end

    it 'succeeds' do
      allow(TwitterFetcher).to receive(:tweets_for).and_return(no_tweets)
      expect(response.status).to eql 200
    end

    context 'when tweets exist' do
      let :mock_db_tweet do
        Struct
          .new(:text, :user_name, :timestamp, :created_at, :save)
          .new(text, user_name, Time.now - 20.minutes, Time.now, true)
      end

      let :tweets do
        (0..24).collect { |_| mock_db_tweet.dup }
      end
      
      render_views

      before do
        allow(TwitterFetcher).to receive(:tweets_for).and_return(many_tweets)
        allow(Tweet).to receive(:from).and_return(mock_db_tweet.dup)
      end

      it 'succeeds' do
        expect(response.status).to eql 200
      end

      it 'responds with tweets' do
        expect(response.body).to match %r/Tweets from #{user.name}/
      end

      it 'caches successive calls' do
        allow(Tweet).to receive(:for) do |user_name|
          # this is little tricky. when first called, this stub will
          # return an empty list, but also re-stubs itself to return
          # the quantity 'tweets', just as if tweets had been persisted 
          allow(Tweet).to receive(:for).with(user_name).and_return(tweets)
          []
        end

        expect(TwitterFetcher).to receive(:tweets_for).once.with(user_name)
        get 'by', params: { tweeter: user_name }
        get 'by', params: { tweeter: user_name }
      end
    end
  end
end
