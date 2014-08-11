require 'rss'

class RssFeedsController < ApplicationController
  before_action :set_rss_feed, only: [:show, :edit, :update, :destroy]

  # GET /rss_feeds
  # GET /rss_feeds.json
  def index
    all_sources = RssFeed.all.map(&:source_url)
    @rss_feeds = {}
    all_sources.each do|source| 
      @rss_feeds[source] = RSS::Parser.parse(open(source).read, false).channel
    end
  end

  def combined_view
    all_sources = RssFeed.all.map(&:source_url)
    @rss_feed_posts = []
    all_sources.each do|source| 
      RSS::Parser.parse(open(source).read, false).channel.items.each {|item| @rss_feed_posts << item }
    end
    @rss_feed_posts.sort_by!(&:pubDate).reverse!
  end

  # GET /rss_feeds/1
  # GET /rss_feeds/1.json
  def show
    @title = RSS::Parser.parse(open(@rss_feed.source_url).read, false).channel.title
  end

  # GET /rss_feeds/new
  def new
    @rss_feed = RssFeed.new
  end

  # GET /rss_feeds/1/edit
  def edit
  end

  # POST /rss_feeds
  # POST /rss_feeds.json
  def create
    @rss_feed = RssFeed.new(rss_feed_params)

    respond_to do |format|
      if @rss_feed.save
        format.html { redirect_to @rss_feed, notice: 'Rss feed was successfully created.' }
        format.json { render action: 'show', status: :created, location: @rss_feed }
      else
        format.html { render action: 'new' }
        format.json { render json: @rss_feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rss_feeds/1
  # PATCH/PUT /rss_feeds/1.json
  def update
    respond_to do |format|
      if @rss_feed.update(rss_feed_params)
        format.html { redirect_to @rss_feed, notice: 'Rss feed was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @rss_feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rss_feeds/1
  # DELETE /rss_feeds/1.json
  def destroy
    @rss_feed.destroy
    respond_to do |format|
      format.html { redirect_to rss_feeds_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rss_feed
      @rss_feed = RssFeed.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rss_feed_params
      params.require(:rss_feed).permit(:source_url)
    end
end
