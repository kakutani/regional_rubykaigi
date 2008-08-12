class AddCommentToAttendees < ActiveRecord::Migration
  def self.up
    add_column :attendees, :comment, :text
  end

  def self.down
    remove_column :attendees, :comment
  end
end
