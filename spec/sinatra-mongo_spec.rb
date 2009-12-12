require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

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
      @app.mongo.name.should            == 'default'
    end

    context 'mongo_url is set' do
      before(:each) do
        @mongo_url = 'mongo://127.0.0.1:27017/test'
        @app.mongo  = @mongo_url
      end

      it 'creates the Mongo::DB instance with the supplied uri' do
        @app.mongo.connection.host.should == '127.0.0.1'
        @app.mongo.connection.port.should == 27017
        @app.mongo.name.should            == 'test'
      end
    end
  end

  describe '#mongo=' do
    before(:each) do
      @mongo_uri  = 'mongo://127.0.0.1:27017/test'
      @mongo      = mock('mongo')
      @app.stub!(:mongo).and_return(@mongo)
    end

    it 'sets the mongo_url environment variable' do
      @app.mongo = @mongo_uri
      @app.mongo_url.should == @mongo_uri
    end

    it 'calls the #mongo method' do
      @app.should_receive(:mongo)
      @app.mongo = @mongo_uri
    end
  end
end

describe 'registration of the extension' do
  before(:each) do
    @app = Sinatra.new
  end

  it 'sets the mongo_url variable' do
    @app.register(Sinatra::MongoExtension)
    @app.mongo_url.should == 'mongo://127.0.0.1:27017/default'
  end

  context "ENV['MONGO_URL'] is set" do
    before(:each) do
      @mongo_url        = 'mongo://127.0.0.1:27017/via_mongo_url_env'
      ENV['MONGO_URL']  = @mongo_url
      @app.register(Sinatra::MongoExtension)
    end
    it 'sets the mongo_url variable to the value of the env variable' do
      @app.mongo_url.should == @mongo_url
    end
  end

  it 'calls helpers with MongoHelper' do
    @app.should_receive(:helpers).with(Sinatra::MongoHelper)
    @app.register(Sinatra::MongoExtension)
  end
end
