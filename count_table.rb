require "connection_establishment"

class CountTable < ActiveRecord::Base
  def before_save
    self.count = 0 if self.count < 0
  end
end
