require 'spec_helper'
require 'rails_helper'

RSpec.describe SitesController do
  let! (:dotandbo) { FactoryGirl.create(:site, url: 'http://www.dotandbo.com') }
  let! (:twitter) { FactoryGirl.build(:site, url: 'http://www.twitter.com') }
  let! (:beatmygoal) { FactoryGirl.build(:site, url: 'http://www.beatmygoal.com') }
  
  context "#show" do
    it "should raise 404 for /sites/unknown_site/" do
      expect {
        get :show, id: 10
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
    
    it "should get /sites/known_id/" do
      get :show, id: dotandbo.id
      response.status.should eq 200
    end
    
    it "should render show template" do
      get :show, id: dotandbo.id
      expect(response).to render_template("show")
    end
  end
  
  context "#show_as_json" do
    it "should raise 404 for /sites/unknown_site/" do
      expect {
        get :show_json, id: 10
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
    
    it "should get /sites/known_id/" do
      get :show_json, id: dotandbo.id
      response.status.should eq 200
    end
    
    it "should respond with json" do
      get :show_json, id: dotandbo.id
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["url"]).to eq "http://www.dotandbo.com"
      expect(parsed_body["has_my_name"]).to eq false
      expect(parsed_body["using_boots_trap"]).to eq true
      expect(parsed_body["emails"]).to eq []
    end
  end
end
