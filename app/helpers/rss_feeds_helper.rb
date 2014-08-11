module RssFeedsHelper
  def find_feed_by_link(source_url)
    RssFeed.where(:source_url => source_url).first
  end

  def custom_timestamp(timestamp)
    timestamp.strftime("%d %b %Y, %H:%M:%S")
  end 
end
