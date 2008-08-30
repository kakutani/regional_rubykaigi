class RemoveActivationRelatedColumnsFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :activation_code
    remove_column :users, :activatted_at
  end

  def self.down
    add_column :users, :activation_code, :string, :limit => 40
    add_column :users, :activation_at, :datetime
  end
end
