class RssFeed < ActiveRecord::Base
  validates :source_url, :presence => true
end
