class AddOfficialTagToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :official_tag, :string
  end

  def self.down
    remove_column :events, :official_tag
  end
end
