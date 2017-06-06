require "#{Dir.pwd}/app/models/tweet"

RSpec.describe Tweet do
  describe '#from' do
    let(:text) { "I'm a tweeter!" }
    let(:created) { Time.now - 10.minutes }
    let(:user) { Struct.new(:name, :id).new("horse_ebooks", 1337) }
    let(:tweet) { Struct.new(:text, :created_at, :user).new("Neigh!", created, user) }

    it 'takes a Tweet object' do
      skip 'sqlite3 for some reason isn\'t playing with RSpec'
      expect(described_class.from(tweet)).to be_instance_of described_class
    end

    xit 'raises an error when required fields are missing' do
      expect { described_class.from('') }.to raise_error NoMethodError
      expect { described_class.from(123) }.to raise_error NoMethodError
      expect { described_class.from(Object.new) }.to raise_error NoMethodError
    end
  end
end
