require 'twitter_fetcher'

RSpec.describe TwitterFetcher do
  ## give your subject a name, so you can reuse it later
  let(:fetcher) { described_class }
  let(:text) { "I'm a tweeter!" }
  let(:created) { Time.now - 10.minutes }
  let(:user) { Struct.new(:name, :id).new("horse_ebooks", 1337) }
  let(:tweet) { Struct.new(:text, :created_at, :user).new(text, created, user) }

  subject { fetcher }

  it 'has an API key' do
    expect(described_class).to respond_to(:api_key)
    expect(described_class.api_key).to eql 'Uc7TDwDP2DRzoe5XsIGUsG3DE'
  end
  
  it 'has an API secret' do
    expect(described_class).to respond_to(:api_secret)
    expect(described_class.api_secret).to eql 'qTy3IzD31Q0tTMQQ5DYJB8aao9Dfj0aBOD8xzh5rx2WRX8oNJO'
  end

  describe '#tweets_for', type: :learning do
    let(:tweets) { fetcher.tweets_for("horse_ebooks") }

    subject { tweets }

    it 'gets tweets for a user' do
      is_expected.to be_instance_of Array
      expect(subject.length).to be > 0
    end

    it 'gets text of tweets' do
      tweets.first.tap do |tweet|
        expect(tweet.text).to be_instance_of String
        expect(tweet.user.name).to be_instance_of String
        expect(tweet.created_at).to be_instance_of Time
      end
    end
    
  end
end
