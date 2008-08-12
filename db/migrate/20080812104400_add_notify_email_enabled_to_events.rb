class AddNotifyEmailEnabledToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :notify_email_enabled, :boolean
  end

  def self.down
    remove_column :events, :notify_email_enabled
  end
end
