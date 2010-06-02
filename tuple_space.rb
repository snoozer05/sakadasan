#!/usr/bin/ruby

require "rinda/tuplespace"

tuple_space = Rinda::TupleSpace.new
DRb.start_service("druby://:11111", tuple_space)
DRb.thread.join
