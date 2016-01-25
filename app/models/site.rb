class Site < ActiveRecord::Base
  validates :url, :format => URI::regexp(%w(http https))
  
  def include_word? word
    !!(/#{word}/ =~ body)
  end
  
  def has_robots?
    !!(robots_body)
  end
  
  def can_fetch?
    has_robots? && robots_rule[uri.path] != "Disallow"
  end
  
  def emails
    addresses = []
    body.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i) do |email|
      addresses << email
    end
    addresses.uniq
  end
  
  def body
    response = Net::HTTP.get_response(uri)
    case response
    when Net::HTTPSuccess
      encode_body(response.body)
    when Net::HTTPRedirection
      self.update_attributes! url: response['location']
      body
    else
      nil
    end
  end
  
  private
  
  def robots_body
    robots_uri = URI("#{uri.scheme}://#{uri.host}/robots.txt")
    response = Net::HTTP.get_response(robots_uri)
    response.kind_of?(Net::HTTPSuccess) ? encode_body(response.body) : nil
  end
  
  def robots_rule
    raw_rule = robots_body
    return if robots_body.nil?
    rules = {}
    raw_rule.split(/[\r\n]+/).each do |line|
      rule = line.split(": ")
      rules[rule[1]] = rule[0]
    end
    rules
  end

  def encode_body(body)
    body.force_encoding('iso-8859-1').encode('utf-8')
  end
  
  def uri
    URI(self.url)
  end
end
