require "connection"

class CreateCountTable < ActiveRecord::Migration
 def self.up
   create_table :count_tables do |t|
     t.column :user_id, :string
     t.column :count, :integer
     t.column :created_at, :datetime
     t.column :update_at, :datetime
   end
 end
 
 def self.down
   drop_table :count_tables
 end
end
