#! ruby -Ku
require "sakada.rb"

sakadasan = Sakada.new
puts sakadasan.carry_zabuton_by_tweet("通常 @sakadasan++","irasally")[0]
puts sakadasan.carry_zabuton_by_tweet("通常 @sakadasan--","irasally")[0]
puts sakadasan.carry_zabuton_by_tweet("たくさん増やす @sakadasan++++++++++","irasally")[0]
puts sakadasan.carry_zabuton_by_tweet("たくさん減らす @sakadasan-----------","irasally")[0]



