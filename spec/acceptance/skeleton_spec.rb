require 'redis'
require 'rredis/server'


TEST_PORT = 6380
describe "Rredis" , :acceptance do
  it "responds to ping" do
    with_server do
      expect(client.ping).to eq("PONG")
    end
  end

  def client
    Redis.new(host: 'localhost', port: TEST_PORT)
  end

  def with_server
    # # add the next three lines to test the tests against a real redis server
    # # the flushall command removes all key values pairs from redis
    # #  start up a test server on our test port
    # # redis-server --port 6380
    # # running the spec agains the real redis server gives "PONG"
    # client.flushall
    # yield
    # return
    server_thread = Thread.new do
      server = Rredis::Server.new(TEST_PORT)
      server.listen
    end

    wait_for_open_port TEST_PORT

    yield
  ensure
    Thread.kill(server_thread) if server_thread
  end

  def wait_for_open_port(port)
    time =  Time.now
    while !check_port(port) && 1 > Time.now - time
      sleep 0.01
    end

    raise TimeoutError unless check_port(port)
  end

  def check_port(port)
    `nc -z localhost #{port}`
    $?.success?
  end
end


