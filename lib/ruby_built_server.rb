require 'socket'
require 'hurley'
require 'time'
# http://127.0.0.1:9292

tcp_server = TCPServer.new(9292)
# client = tcp_server.accept
i = -1
circuitbreaker = 0
response_count = -1
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

  first_line = request_lines[0].split(" ")
  verb = first_line[0]
  path = first_line[1]
  protocol = first_line[2]

  fourth_line = request_lines[3].split(": ")
  accept = fourth_line[1]

  sixth_line = request_lines[5].split(":")
  host = sixth_line[1]
  origin = sixth_line[1]
  port = sixth_line[2]

  request_parse =   ("Verb: #{verb}\n" +
                     "Path: #{path}\n" +
                     "Protocol: #{protocol}\n" +
                     "Host: #{host}\n" +
                     "Port: #{port}\n" +
                     "Origin: #{origin}\n" +
                     "Accept: #{accept}\n")
  response_count += 1
  if path == "/"
    response = request_parse
  elsif path == "/hello"
    response = "Hello, World! (#{i += 1})\n" + request_parse
  elsif path == "/hello_restart"
    i = -1
    response = request_parse
  elsif path == "/datetime"
    response = "#{Time.new.strftime("%I:%M%p on %A, %B %d, %Y")}\n" + request_parse
  elsif path == "/shutdown"
    response = "Total Requests: #{response_count}\n" + request_parse
    circuitbreaker = 1
  elsif path == "/shutdown_restart"
    response_count = -1
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
