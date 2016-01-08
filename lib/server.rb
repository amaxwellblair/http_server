require 'pry'


class Server
  attr_accessor :client, :empty_lines

  def initialize(server)
    @client = server.accept
    @empty_lines = 0
  end

  def receive_request
    i = 0
    puts "Ready for a request"
    request_lines = []

    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    if request_lines[3].include?("Content-Length")
       num = request_lines[3].split(" ")[1]
       request_lines << client.read(num.to_i)
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
