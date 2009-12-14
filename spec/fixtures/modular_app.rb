require 'sinatra/base'
require 'sinatra/mongo'

class ModularApp < Sinatra::Base
  register Sinatra::MongoExtension

  set :mongo, 'mongo://localhost:27017/sinatra-mongo-test'

  get '/' do
    mongo['test_collection'].find_one.inspect
  end
end

