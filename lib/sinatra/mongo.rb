require 'sinatra/base'
require 'mongo'

module Sinatra
  module MongoHelper
    def mongo
      options.mongo
    end
  end

  module MongoExtension
    def mongo=(url)
      @mongo = nil
      set :mongo_url, url
      mongo
    end

    def mongo
      return @mongo unless @mongo.nil?
      @mongo_lock ||= Mutex.new
      @mongo_lock.synchronize do
        @mongo ||= (
          url = URI(mongo_url)
          connection = Mongo::Connection.new(url.host, url.port)
          mongo = connection.db(url.path[1..-1], mongo_settings)
          if url.user && url.password
            mongo.authenticate(url.user, url.password)
          end
          mongo
        )
      end
    end

    protected

    def self.registered(app)
      app.set :mongo_url, ENV['MONGO_URL'] || 'mongo://127.0.0.1:27017/default'
      app.set :mongo_settings, Hash.new
      app.helpers MongoHelper
    end

  end

  register MongoExtension

end
