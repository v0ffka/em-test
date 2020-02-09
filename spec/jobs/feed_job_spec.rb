require 'rails_helper'

RSpec.describe FeedJob, type: :job do
  describe '.perform' do
    let(:feed_url) { 'http://feed.url' }
    let(:feed) { create(:feed, url: feed_url)}

    before do
      stub_request(:get, feed_url).to_return(body: File.read('spec/support/rss-example.xml'))
    end

    it 'reads from feed' do
      # example is 50 item, but we will skip item w/o guid
      expect { FeedJob.perform_now(feed.id); feed.reload }.to change { feed.last_updated_at }
                                                         .and change { feed.feed_items.count }.by(47)

      # duplicates won't load
      expect { FeedJob.perform_now(feed.id) }.not_to change { feed.feed_items.count }

      item_sample = FeedItem.find('xi-jinping-turned-invisible-during-103500508.html')
      expect(item_sample.link).to eq('https://news.yahoo.com/xi-jinping-turned-invisible-during-103500508.html')
      expect(item_sample.title).to eq('Xi Jinping has turned invisible during China&#39;s coronavirus epidemic, likely to cover his back in case things go badly wrong')
      expect(item_sample.pub_date).to eq('Sat, 08 Feb 2020 10:35:00')
    end
  end
end
