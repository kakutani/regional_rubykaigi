class AddRemoteIpToAttendees < ActiveRecord::Migration
  def self.up
    add_column :attendees, :remote_ip, :string
  end

  def self.down
    remove_column :attendees, :remote_ip
  end
end
