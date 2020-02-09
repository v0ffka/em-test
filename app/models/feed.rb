class Feed < ApplicationRecord
  has_many :feed_items, dependent: :delete_all

  after_create_commit :schedule_feed_job

  private

  def schedule_feed_job
    FeedJob.perform_later(id)
  end
end
