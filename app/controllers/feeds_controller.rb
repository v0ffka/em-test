class FeedsController < ApplicationController
  before_action :find_feed, except: %i[index create]

  def index
    render json: Feed.all
  end

  def show
    render json: @feed
  end

  def create
    @feed = Feed.create(feed_params)
    render json: @feed, status: :created
  end

  def update
    @feed.update(feed_params)
    render json: @feed, status: :ok
  end

  def destroy
    @feed.destroy
    head :no_content
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: e.message }, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { error: e.message }, status: :forbidden
  end

  private

  def feed_params
    params.permit(:url)
  end

  def find_feed
    @feed = Feed.find(params[:id])
  end
end
