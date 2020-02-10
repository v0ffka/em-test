require 'rails_helper'

RSpec.describe 'RSS Reader', type: :feature do
  before { WebMock.allow_net_connect! }

  describe 'reader functionality', js: true do
    before do
      feed = create(:feed, url: 'The URL 1', title: 'The Feed')
      5.times.each { |i| feed.feed_items.create(guid: SecureRandom.hex, title: "Some article 1#{i}", link: 'yandex.ru', pub_date: Date.yesterday + rand(10))}
      other_feed = create(:feed, url: 'The URL 2', title: 'The Feed 2')
      5.times.each { |i| other_feed.feed_items.create(guid: SecureRandom.hex, title: "Some article 2#{i}", link: 'yandex.ru', pub_date: Date.yesterday + rand(10))}

      visit '/reader'
    end

    it 'displays all reader feeds' do
      # this is ugly but quick and effective way of testing appearence in the right order
      articles_raw_string = FeedItem.all_recent.pluck('title').join("\n")

      expect(page).to have_content(articles_raw_string)
    end
  end
end
