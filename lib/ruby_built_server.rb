$LOAD_PATH.unshift(__dir__)

require 'socket'
require 'hurley'
require 'time'
require 'request'
# http://127.0.0.1:9292

DICT = File.readlines("/usr/share/dict/words")
hello_count = -1
circuitbreaker = 0
response_count = -1
tcp_server = TCPServer.new(9292)

while true
  client = tcp_server.accept
  puts "Ready for a request"
  request_lines = []
  while line = client.gets and !line.chomp.empty?
    request_lines << line.chomp
  end

  puts "Got this request:"
  puts request_lines.inspect
  puts "Sending response."

  request = Request.new(request_lines)

  puts request

  response_count += 1
  if request.path == "/"
    response = request.parse
  elsif request.path == "/hello"
    response = "Hello, World! (#{hello_count += 1})\n" + request.parse
  elsif request.path == "/hello_restart"
    hello_count = -1
    response = request.parse
  elsif request.path == "/datetime"
    response = "#{Time.new.strftime("%I:%M%p on %A, %B %d, %Y")}\n" + request.parse
  elsif request.path == "/shutdown"
    response = "Total Requests: #{response_count}\n" + request.parse
    circuitbreaker = 1
  elsif request.path == "/shutdown_restart"
    response_count = -1
  elsif request.path == "/word_search"
    if DICT.any?{|word| word.chomp == request.param[:word]}
      response = "WORD is a known word"
    else
      response = "WORD is not a known word"
    end
  else
    response = request.parse
  end



  output = "<html><head></head><body><pre>#{response}</pre></body></html>"
  headers = ["http/1.1 200 ok",
            "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
            "server: ruby",
            "content-type: text/html; charset=iso-8859-1",
            "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  client.puts headers
  client.puts output

  puts ["Wrote this response:", headers, output].join("\n")

  client.close
  puts "\nResponse complete"

  if circuitbreaker == 1
    break
  end
end
