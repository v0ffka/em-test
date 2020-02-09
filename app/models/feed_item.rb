class FeedItem < ApplicationRecord
  belongs_to :feed

  validates_presence_of :guid, :title, :link

  scope :all_recent, -> { order('pub_date desc') }
end
