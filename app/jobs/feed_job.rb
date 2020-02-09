require 'open-uri'
require 'rss'

class FeedJob < ApplicationJob
  queue_as :default

  def perform(feed_id)
    feed = Feed.find(feed_id)

    pull_feed_data(feed)
  end

  private

  def pull_feed_data(feed)
    return unless feed.url

    open(feed.url) do |rss|
      rss_feed = RSS::Parser.parse(rss)

      rss_feed.items.each do |item|
        create_feed_item(feed, item)
      end

      set_feed_params(feed, title: rss_feed.channel.title)
    end
  end

  def set_feed_params(feed, params = {})
    feed.update!(params.merge(last_updated_at: Time.now))
  end

  def create_feed_item(feed, item)
    #skip existing
    return if feed.feed_items.where(guid: item.guid.content).exists?

    if item.guid.content.empty?
      warn('RSS element has no guid, skipped')
      warn(item.link)
      return
    end

    feed.feed_items.create!(guid: item.guid.content,
                            title: item.title,
                            link: item.link,
                            pub_date: item.pubDate)
  end
end
