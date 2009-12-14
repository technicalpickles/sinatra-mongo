require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'fixtures/classic_app'

describe 'a classic style sinatra app' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'GET /' do
    before(:each) do
      3.times { |i| mongo['test_collection'].insert({'x' => i }) }
    end

    after(:each) do
      mongo['test_collection'].remove
    end

    it 'fetches and shows the first element in test_collection' do
      get '/' do |response|
        response.body.should match('"x"=>0')
      end
    end

  end

end
