class AddMessageOfTheDayAfterToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :message_of_the_day_after, :text, :default => "", :null => false
    Event.find(:all).each { |e| e.message_of_the_day_after.nil? && e.message_of_the_day_after = ""; e.save}
  end

  def self.down
    remove_column :events, :message_of_the_day_after
  end
end
