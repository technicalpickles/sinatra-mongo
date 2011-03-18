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
      @mongo_replicaset_config = nil
      mongo
    end

    def mongo_replicaset_config=(hash)
      @mongo = nil
      set :mongo_url, nil
      @mongo_replicaset_config = hash
      mongo
    end

    def mongo
      return @mongo unless @mongo.nil?
      @mongo_lock ||= Mutex.new
      @mongo_lock.synchronize do
        @mongo ||= (
          if mongo_url
            url = URI(mongo_url)
            connection = Mongo::Connection.new(url.host, url.port)
            mongo = connection.db(url.path[1..-1], mongo_settings)
            if url.user && url.password
              mongo.authenticate(url.user, url.password)
            end
          elsif @mongo_replicaset_config
            hosts = @mongo_replicaset_config[:hosts]
            database = @mongo_replicaset_config[:database]
            read_secondary = @mongo_replicaset_config[:read_secondary] || false
            raise "hosts required" if hosts.nil?
            raise "database required" if database.nil?
            connection = Mongo::ReplSetConnection.new(hosts, :read_secondary => read_secondary)
            mongo = connection.db(database, mongo_settings)
            username = @mongo_replicaset_config[:username]
            password = @mongo_replicaset_config[:password]
            if username && password
              mongo.authenticate(username, password)
            end
          else
            mongo = nil
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
