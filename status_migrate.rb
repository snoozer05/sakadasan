require "connection"

class CreateStatus < ActiveRecord::Migration
  def self.up
    execute <<-EOQ
      create table statuses (
        id          int8 unsigned not null primary key auto_increment,
        status_id   int8 unsigned not null,
        screen_name varchar(15)   not null,
        text        text          not null,
        in_reply_to int8 unsigned,
        created_at  datetime      not null,
        updated_at  datetime      not null);
    EOQ
    add_index :statuses, :status_id
    add_index :statuses, :screen_name
    add_index :statuses, :in_reply_to
    add_index :statuses, [:status_id, :in_reply_to]
  end
 
  def self.down
    drop_table :statuses
  end
end
