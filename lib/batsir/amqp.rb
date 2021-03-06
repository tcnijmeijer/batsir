module Batsir
  module AMQP
    attr_accessor :queue
    attr_accessor :host
    attr_accessor :port
    attr_accessor :username
    attr_accessor :password
    attr_accessor :vhost
    attr_accessor :exchange

    def bunny_options
      {
        :host  => host,
        :port  => port,
        :user  => username,
        :pass  => password,
        :vhost => vhost
      }
    end

    def host
      @host ||= Batsir::Config.fetch(:amqp_host, 'localhost')
    end

    def port
      @port ||= Batsir::Config.fetch(:amqp_port, 5672)
    end

    def username
      @username ||= Batsir::Config.fetch(:amqp_user, 'guest')
    end

    def password
      @password ||= Batsir::Config.fetch(:amqp_pass, 'guest')
    end

    def vhost
      @vhost ||= Batsir::Config.fetch(:amqp_vhost, '/')
    end

    def exchange
      @exchange ||= Batsir::Config.fetch(:amqp_exchange, 'amq.direct')
    end

    def bunny_pool_key
      "bunny_pool_for_#{host}_#{port}_#{vhost}"
    end

    def bunny_pool
      @bunny_pool = Batsir::Registry.get(bunny_pool_key)
      if !@bunny_pool
        bunny_pool_size = Batsir::Config.connection_pool_size
        pool = ConnectionPool.new(:size => bunny_pool_size) { Bunny.new(bunny_options).start }
        @bunny_pool = Batsir::Registry.register(bunny_pool_key, pool)
      end
      @bunny_pool
    end
  end
end
