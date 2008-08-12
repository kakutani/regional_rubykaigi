class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.string :title
      t.text :desc
      t.timestamp :publish_at
      t.integer :capacity
      t.boolean :force_disabled

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
