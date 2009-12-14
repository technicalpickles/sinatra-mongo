require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'fixtures/modular_app'

describe 'a modular style sinatra app' do
  include Rack::Test::Methods

  def app
    ModularApp
  end

  it_should_behave_like 'all sinatra-mongo test apps'

end
