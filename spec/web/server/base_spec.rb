require 'spec_helper'
require 'ronin/web/server/base'

require 'web/server/classes/test_app'
require 'web/helpers/rack_app'

describe Web::Server::Base do
  include Helpers::Web::RackApp

  before(:all) do
    self.app = TestApp
  end

  it "should still bind blocks to paths" do
    get '/tests/get'

    last_response.should be_ok
    last_response.body.should == 'block tested'
  end

  it "should bind a block to a path for all request types" do
    post '/tests/any'

    last_response.should be_ok
    last_response.body.should == 'any tested'
  end

  it "should have a default response" do
    get '/totally/non/existant/path'

    last_response.should_not be_ok
    last_response.body.should be_empty
  end

  it "should allow for defining custom responses" do
    TestApp.default do
      halt 404, 'nothing to see here'
    end

    get '/whats/here'

    last_response.should_not be_ok
    last_response.body.should == 'nothing to see here'
  end

  it "should map paths to sub-apps" do
    get '/tests/subapp/'

    last_response.should be_ok
    last_response.body.should == 'SubApp'
  end

  it "should not modify the path_info as it maps paths to sub-apps" do
    get '/tests/subapp/hello'

    last_response.should be_ok
    last_response.body.should == 'SubApp greets you'
  end

  it "should host static content from public directories" do
    get '/static1.txt'

    last_response.should be_ok
    last_response.body.should == "Static file1.\n"
  end

  it "should host static content from multiple public directories" do
    get '/static2.txt'

    last_response.should be_ok
    last_response.body.should == "Static file2.\n"
  end
end
