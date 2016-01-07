class Server
  attr_accessor :client

  def initialize(server)
    @client = server.accept
  end

  def receive_request
    puts "Ready for a request"
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    puts "Got this request:"
    puts request_lines.inspect
    request_lines
  end

  def send_response(output, headers)
    client.puts headers.create
    client.puts output
    puts ["Wrote this response:", headers.create, output].join("\n")
    puts "\nResponse complete"
    client.close
  end

  def shut_down?(output)
    output.include?("Total Requests:")
  end

end
