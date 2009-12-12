require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'mongo'

describe "Sinatra::MongoExtension" do

  before(:each) do
    @app = Sinatra.new
    @app.register Sinatra::MongoExtension
  end

  describe '#mongo' do
    it 'creates and returns a Mongo::DB instance' do
      @app.mongo.should be_kind_of(Mongo::DB)
    end

    it 'defaults to a db on localhost called default' do
      @app.mongo.connection.host.should == '127.0.0.1'
      @app.mongo.connection.port.should == 27017
      @app.mongo.name.should == 'default'
    end

    context 'mongo_url is set' do
      before(:each) do
        #@app.mongo  = 'mongo://127.0.0.1:1111/test'
        #@connection = mock('connection')
        #@mongo      = mock('mongo')
        #Mongo::Connection.stub!(:new).and_return(@connection)
        #@connection.stub!(:db).with('test').and_return(@mongo)
      end

      it 'creates the Mongo::DB instance with the supplied uri' do
        pending
        #@app.mongo.connection.port.should == 1111
      end
    end
  end


end
