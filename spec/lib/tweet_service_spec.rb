require 'tweet_service'

RSpec.describe TweetService do
  describe '#tweets_for' do
    let(:tweets_for) { described_class.tweets_for(user_name) }

    let(:user_name) { 'rando_calrissian' }
    let(:text) { %q{I'm a tweeter!} }
    let(:timestamp) { Time.now - 1.year }

    let :tweet do
      Struct
        .new(:text, :user_name, :timestamp, :created_at, :save)
        .new(text, user_name, timestamp, Time.now, true)
    end

    subject { tweets_for }
    
    let :fresh_tweets do
      (0..24).collect do |i|
        tweet.dup.tap { |t| t.created_at = Time.now - 2.minutes }
      end
    end

    it 'checks the datastore for tweets' do
      expect(Tweet).to receive(:for).with(user_name).and_return([])
      allow(Tweet).to receive(:clear).with(user_name).and_return true
      allow(TwitterFetcher).to receive(:tweets_for).with(user_name).and_return([])

      subject
    end

    it 'when cached tweets exist returns them' do
      allow(Tweet).to receive(:for).with(user_name).and_return(fresh_tweets)
      allow(Tweet).to receive(:clear).with(user_name).and_return true
      expect(TwitterFetcher).not_to receive(:tweets_for)
      
      subject
    end

    context 'fetches tweets' do
      let :stale_tweets do
        (0..24).collect do |i|
          tweet.dup.tap { |t| t.created_at = Time.now - 12.minutes }
        end
      end

      it 'when the database results are missing' do
        allow(Tweet).to receive(:for).with(user_name).and_return([])
        allow(Tweet).to receive(:clear).with(user_name).and_return true

        expect(TwitterFetcher).to receive(:tweets_for).with(user_name).once.and_return([])

        subject
      end

      it 'when cached tweets are stale' do
        allow(Tweet).to receive(:for).with(user_name).and_return(stale_tweets)
        allow(Tweet).to receive(:clear).with(user_name).and_return true

        expect(TwitterFetcher).to receive(:tweets_for).with(user_name).once.and_return([])

        subject
      end

      it 'persists tweets to the database' do
        allow(Tweet).to receive(:for).with(user_name).and_return(stale_tweets)
        allow(Tweet).to receive(:clear).with(user_name).and_return true

        allow(TwitterFetcher).to receive(:tweets_for).with(user_name).and_return(fresh_tweets)

        expect(Tweet).to receive(:from).exactly(25).times.and_return(tweet)

        subject
      end
    end
  end
end
