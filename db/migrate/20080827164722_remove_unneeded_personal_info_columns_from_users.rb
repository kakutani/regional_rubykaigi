class RemoveUnneededPersonalInfoColumnsFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :name
    remove_column :users, :email
  end

  def self.down
    add_column :users, :name, :string, :limit => 100, :default => ""
    add_column :users, :email, :string, :limit => 100
  end
end
