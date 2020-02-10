class HomeController < ActionController::Base
  layout 'application'

  def index

  end

  def reader
    @articles = FeedItem.all_recent
  end
end