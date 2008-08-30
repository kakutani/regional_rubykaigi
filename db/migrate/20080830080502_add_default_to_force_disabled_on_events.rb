class AddDefaultToForceDisabledOnEvents < ActiveRecord::Migration
  def self.up
    change_column_default(:events, :force_disabled, false)
  end

  def self.down
    change_column_default(:events, :force_disabled, nil)
  end
end
