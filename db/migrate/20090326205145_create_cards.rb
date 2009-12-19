class CreateCards < ActiveRecord::Migration
  def self.up
    create_table :cards do |t|
      t.integer :order_id, :month, :year, :authorization
      t.string :card_type, :card_number, :security_code
      t.timestamps
    end
  end

  def self.down
    drop_table :cards
  end
end
