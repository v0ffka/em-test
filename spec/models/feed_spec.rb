require 'rails_helper'

RSpec.describe Feed, type: :model do
  describe 'adding new feed' do
    it 'schedules feed job after creation' do
      feed_id = nil

      expect { feed_id = Feed.create(title: 'some', url: 'http://some') }.to have_enqueued_job(FeedJob).with(feed_id)
    end
  end

  describe 'feed removal' do
    let(:feed) { create(:feed) }

    before do
      5.times { |i| feed.feed_items.create(guid: "guid#{i}", title: 'some', link: 'link') }
    end

    it 'drops related feed items' do
      expect { feed.destroy }.to change { FeedItem.count }.by(-5)
                            .and change { Feed.count }.by(-1)
    end
  end
end
