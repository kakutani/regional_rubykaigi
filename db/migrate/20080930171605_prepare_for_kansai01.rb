class PrepareForKansai01 < ActiveRecord::Migration
  def self.up
    rename_column :events, :scheduled_on, :start_on
    add_column :events, :end_on, :date
    Event.find(:all, :conditions => ["end_on is NULL"]).each do |event|
      event.end_on = event.start_on;event.save
    end
    add_column :events, :use_builtin_registration, :boolean, :null => false, :default => true
    Event.find(:all, :conditions => ["use_builtin_registration is NULL"]).each do |event|
      event.use_builtin_registration = true; event.save
    end
    add_column :events, :register_information, :text, :null => true
    change_column :events, :capacity, :integer, :null => false, :default => 0
  end

  def self.down
    rename_column :events, :start_on, :scheduled_on
    remove_column :events, :end_on
    remove_column :events, :use_builtin_registration
    remove_column :events, :register_information
  end
end
