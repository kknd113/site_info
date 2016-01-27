require 'spec_helper'
require 'rails_helper'

describe Site do
  let (:dotandbo) { FactoryGirl.create(:site, url: 'http://www.dotandbo.com') }
  let (:twitter) { FactoryGirl.create(:site, url: 'http://www.twitter.com') }
  let (:beatmygoal) { FactoryGirl.create(:site, url: 'http://www.beatmygoal.com') }
  
  it "is invalid with no url" do
    FactoryGirl.build(:site, url: nil).should_not be_valid
  end
  
  it "is invalid with invalid url" do
    FactoryGirl.build(:site, url: 'htt://www.dotandbo.com').should_not be_valid
  end
  
  it "is valid with a valid url" do
    FactoryGirl.create(:site, url: 'http://www.dotandbo.com').should be_valid
  end
  
  context "#body" do
    it "returns the body of the site when it doesn't redirect" do
      dotandbo.body.should_not be_nil
    end
    
    it "returns the body of the site when it doesn't redirect and should update url" do
      twitter.body.should_not be_nil
      twitter.url.starts_with?('https').should be_truthy
    end
  end
  
  context '#include_word?' do

    it "returns true if the body includes the word" do
      dotandbo.include_word?('chris').should be_truthy
    end
    
    it "returns false if the body does not include the word" do
      twitter.include_word?('chris').should be_falsey
    end
  end
  
  xcontext '#has_robots?' do
    it "returns true if the site has /robots.txt endpoint" do
      dotandbo.has_robots?.should be_truthy
    end
    
    it "returns true if the site has /robots.txt endpoint" do
      beatmygoal = FactoryGirl.create(:site, url: 'http://www.beatmygoal.com')
      beatmygoal.has_robots?.should be_falsey
    end
  end
  
  context '#can_fetch?' do
    it "returns true if the page is not explicitly disallowed by robots.txt" do
      dotandbo.can_fetch?.should be_truthy
    end
    
    it "returns true if the site has /robots.txt endpoint" do
      dotandbo_cart = FactoryGirl.create(:site, url: 'http://www.dotandbo.com/cart')
      dotandbo_cart.can_fetch?.should be_falsey
    end
  end
  
  context "#emails" do
    it "returns empty list if the body has no email addresses" do
      dotandbo.emails.should be_empty
    end
    
    it "returns list of emails if the body has one email address" do
      dotandbo_about = FactoryGirl.create(:site, url: 'http://www.dotandbo.com/about')
      dotandbo_about.emails.include?("careers@dotandbo.com").should be_truthy
    end
    
    it "returns list of emails if the body has multiple email addresses" do
      dotandbo_contact = FactoryGirl.create(:site, url: 'http://www.dotandbo.com/contact')
      emails = dotandbo_contact.emails
      emails.count.should eq 2
      emails.include?("press@dotandbo.com").should be_truthy
      emails.include?("careers@dotandbo.com").should be_truthy
    end
  end
  
  xcontext "private methods" do
    context "#robots_body" do
      it "should return robots.txt body if it has one" do
        dotandbo.send(:robots_body).should_not be_nil
      end
    
      it "shouuld return nil if it does not have robots.txt" do
        beatmygoal.send(:robots_body).should be_nil
      end
    end
    
    context "#robots_rule" do
      it "should return robots rule in hash if it has robots.txt" do
        rules = dotandbo.send(:robots_rule)
        rules.should_not be_nil
        rules.kind_of?(Hash).should be_truthy
      end
      
      it "should return nil if it does not have robots.txt" do
        beatmygoal.send(:robots_rule).should be_nil
      end
    end
    
    context "#uri" do
      it "should return valid URI object" do
        uri = dotandbo.send(:uri)
        uri.scheme.should eq 'http'
        uri.host.should eq 'www.dotandbo.com'
        uri.path.should eq ''
      end
    end
  end
  
  
end
