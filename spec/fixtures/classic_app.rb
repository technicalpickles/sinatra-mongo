require 'sinatra'
require 'sinatra/mongo'

set :mongo, 'mongo://localhost:27017/sinatra-mongo-test'

get '/' do
  mongo['test_collection'].find_one.inspect
end
