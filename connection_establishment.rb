require "rubygems"
require "pit"
require "active_record"

config = Pit.get(:mysql_account)

ActiveRecord::Base.establish_connection(
  :adapter  => "mysql",
  :host     => "localhost",
  :username => config[:username],
  :password => config[:password],
  :database => "sakadasan",
  :timeout  => 3600000)
