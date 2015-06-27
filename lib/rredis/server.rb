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
      # arguments sent to the redis server have a format of
      # *<number of arguments> CR LF
      loop do
        header = client.gets.to_s

        return unless header[0] == '*'

        number_of_arguments = header[1..-1].to_i

        # we loop number of arument times and get all values
        cmd = number_of_arguments.times.map do
          length = client.gets[1..-1].to_i
          # length +2 because of \n and \r
          client.read(length + 2).chomp
        end

        response = case cmd[0].downcase
          when 'ping' then "+PONG\r\n"
          when 'echo' then "$#{cmd[1].length}\r\n#{cmd[1]}\r\n"
          end


        client.write response
      end
    ensure
      client.close
    end
  end
end
