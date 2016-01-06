# Automated server start and test suite run


# `ruby ./lib/ruby_built_server.rb &>/dev/null &`
# `screen -d -m -S "Ruby Server" ruby ./lib/ruby_built_server.rb`


# probaly want to create a bash script to run both more effectively
# doesn't properly open and close at the moment
# Easy server testing: (bash script)
# server_test () { ruby ./lib/ruby_built_server.rb &>/dev/null &
# mrspec;
# ruby ./lib/shut_down.rb;
# }
