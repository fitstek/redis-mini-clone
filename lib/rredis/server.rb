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
      # we put the ensure to make sure that our sockets are closed
      # otherwise as in the case of the echo spec it hangs
      ensure
        socket.close if socket
    end

    def handle_client(client)
      client.write "+PONG\r\n"
    ensure
      client.close
    end
  end
end
