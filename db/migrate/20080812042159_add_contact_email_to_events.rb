class AddContactEmailToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :contact_email, :string
  end

  def self.down
    remove_column :events, :contact_email
  end
end
