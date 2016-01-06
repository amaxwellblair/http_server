require 'hurley'

client = Hurley::Client.new "http://127.0.0.1:9292"
path = "/shutdown"
response = client.get path do |req|
  req.url
end
