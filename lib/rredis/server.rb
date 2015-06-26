require 'socket'

module Rredis
  class Server
    attr_reader :port
    def initialize(port)
      @port = port
    end

    def listen
      socket = TCPServer.new(port)

      loop { handle_client socket.accept }
    end

    def handle_client(client)
      client.write "+PONG\r\n"
    ensure
      client.close
    end
  end
end
