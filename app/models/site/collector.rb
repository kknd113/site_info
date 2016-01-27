class Site
  class Collector
    attr_accessor :site, :uri, :body, :robots_body
    def initialize(site)
      @site = site
      @uri = URI(@site.url)
    end
    
    def collect_body
      response = Net::HTTP.get_response(@uri)
      case response
      when Net::HTTPSuccess
        encode_body(response.body)
      when Net::HTTPRedirection
        @site.update_attributes! url: response['location']
        self.uri = URI(@site.url)
        collect_body
      else
        nil
      end
    end
    
    def collect_robots_body
      robots_uri = URI("#{@uri.scheme}://#{@uri.host}/robots.txt")
      response = Net::HTTP.get_response(robots_uri)
      response.kind_of?(Net::HTTPSuccess) ? encode_body(response.body) : nil
    end
    
    private
    
    def encode_body(body)
      body.force_encoding('iso-8859-1').encode('utf-8')
    end
  end
end
