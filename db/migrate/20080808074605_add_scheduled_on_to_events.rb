class AddScheduledOnToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :scheduled_on, :date
  end

  def self.down
    remove_column :events, :scheduled_on
  end
end
