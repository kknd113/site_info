class Site < ActiveRecord::Base
  attr_reader :body, :robots_body
  
  validates :url, :format => URI::regexp(%w(http https))
  
  def include_word? word
    Processor.new(body, robots_body, uri).process_word?(word)
  end
  
  def can_fetch?
    Processor.new(body, robots_body, uri).can_fetch?
  end
  
  def emails
    Processor.new(body, robots_body, uri).process_emails
  end
  
  def body
    @body ||= Collector.new(self).collect_body
  end
  
  def robots_body
    @robots_body ||= Collector.new(self).collect_robots_body
  end
  
  private
  
  def uri
    URI(self.url)
  end
end
