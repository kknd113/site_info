class Site
  class Processor
    
    def initialize(body, robots_body, uri)
      @body = body
      @robots_body = robots_body
      @uri = uri
    end
    
    def process_emails
      addresses = []
      @body.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i) do |email|
        addresses << email
      end
      addresses.uniq
    end
    
    def process_word? word
      !!(/#{word}/ =~ @body)
    end
    
    def can_fetch?
      has_robots? && robots_rule[@uri.path] != "Disallow"
    end
    
    
    private
    
    def has_robots?
      !!(@robots_body)
    end
    
    def robots_rule
      raw_rule = @robots_body
      return if @robots_body.nil?
      rules = {}
      raw_rule.split(/[\r\n]+/).each do |line|
        rule = line.split(": ")
        rules[rule[1]] = rule[0]
      end
      rules
    end
    
  end
end
