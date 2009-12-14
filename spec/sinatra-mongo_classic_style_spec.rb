require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'fixtures/classic_app'

describe 'a classic style sinatra app' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it_should_behave_like 'all sinatra-mongo test apps'

end
