#!/usr/bin/ruby

require "updater"
require "rinda/tuplespace"

tuple_space = Rinda::TupleSpace.new
DRb.start_service(Updater::DRbURI, tuple_space)
DRb.thread.join
