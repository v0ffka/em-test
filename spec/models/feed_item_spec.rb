require 'rails_helper'

RSpec.describe FeedItem, type: :model do
  describe 'listing' do
    let(:feed) { create(:feed) }
    let(:other_feed) { create(:feed) }

    before {
      5.times { |i| feed.feed_items.create(guid: "guid1#{i}", title: 'feed item', link: 'link') }
      3.times { |i| other_feed.feed_items.create(guid: "guid2#{i}", title: 'other feed item', link: 'link') }
    }

    it 'list only feed items' do
      expect(feed.feed_items.all_recent.count).to eq(5)
    end

    it 'list all items' do
      expect(FeedItem.all_recent.count).to eq(8)
    end
  end
end
