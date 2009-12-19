class CreateOrderItems < ActiveRecord::Migration
  def self.up
    create_table :order_items do |t|
      t.string :name, :permalink
      t.integer :order_id, :quantity, :total
      t.float :price, :sale_price, :real_price
      t.timestamps
    end
  end

  def self.down
    drop_table :order_items
  end
end
